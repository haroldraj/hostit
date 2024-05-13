package com.train.hostit_synchro.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.file.*;
import static java.nio.file.StandardWatchEventKinds.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class FileWatcherService {

    private final ExecutorService executor;
    private final SyncService syncService;
    private WatchService watchService;

    @Autowired
    public FileWatcherService(SyncService syncService) {
        this.syncService = syncService;
        this.executor = Executors.newSingleThreadExecutor();
        initializeWatchService();
    }

    private void initializeWatchService() {
        try {
            this.watchService = FileSystems.getDefault().newWatchService();
        } catch (Exception e) {
            throw new RuntimeException("Could not create watch service", e);
        }
    }

    public void watchDirectory(Path pathToWatch) {
        try {
            pathToWatch.register(watchService, ENTRY_CREATE, ENTRY_DELETE, ENTRY_MODIFY);
            startWatching();
        } catch (Exception e) {
            throw new RuntimeException("Could not register path with watch service", e);
        }
    }

    private void startWatching() {
        executor.submit(() -> {
            try {
                while (true) {
                    WatchKey key = watchService.take();
                    for (WatchEvent<?> event : key.pollEvents()) {
                        WatchEvent.Kind<?> kind = event.kind();

                        @SuppressWarnings("unchecked")
                        WatchEvent<Path> ev = (WatchEvent<Path>) event;
                        Path fileName = ev.context();

                        System.out.printf("Event kind: %s for file: %s%n", kind.name(), fileName);

                        // Trigger a sync operation
                        syncService.triggerSyncOperation(fileName, kind);
                    }
                    boolean valid = key.reset();
                    if (!valid) {
                        break;
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } catch (ClosedWatchServiceException e) {
                System.out.println("Watch service closed");
            }
        });
    }

    public void stopWatching() {
        try {
            watchService.close();
        } catch (Exception e) {
            throw new RuntimeException("Could not close watch service", e);
        } finally {
            executor.shutdownNow();
        }
    }
}
