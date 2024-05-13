package com.train.hostit_synchro.repository;

import com.train.hostit_synchro.model.SyncHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SyncHistoryRepository extends JpaRepository
{
    List<SyncHistory> findBySyncJobId(Long syncJobId);

    List<SyncHistory> findBySyncJobIdAndStatus(Long syncJobId, String status);

    List<SyncHistory> findByStatus(String status);

    List<SyncHistory> findByEventTimeBetween(String startTime, String endTime);

    List<SyncHistory> findByEventTimeAfter(String startTime);

    List<SyncHistory> findByEventTimeBefore(String endTime);

    List<SyncHistory> findByEventTimeAfterAndStatus(String startTime, String status);

    List<SyncHistory> findByEventTimeBeforeAndStatus(String endTime, String status);

    List<SyncHistory> findByEventTimeBetweenAndStatus(String startTime, String endTime, String status);

    List<SyncHistory> findBySyncJobIdAndEventTimeBetween(Long syncJobId, String startTime, String endTime);

    List<SyncHistory> findBySyncJobIdAndEventTimeAfter(Long syncJobId, String startTime);

    List<SyncHistory> findBySyncJobIdAndEventTimeBefore(Long syncJobId, String endTime);

    List<SyncHistory> findBySyncJobIdAndEventTimeAfterAndStatus(Long syncJobId, String startTime, String status);

    List<SyncHistory> findBySyncJobIdAndEventTimeBeforeAndStatus(Long syncJobId, String endTime, String status);

    List<SyncHistory> findBySyncJobIdAndEventTimeBetweenAndStatus(Long syncJobId, String startTime, String endTime, String status);

    List<SyncHistory> findBySyncJobIdAndStatusAndEventTimeBetween(Long syncJobId, String status, String startTime, String endTime);

    List<SyncHistory> findBySyncJobIdAndStatusAndEventTimeAfter(Long syncJobId, String status, String startTime);

    List<SyncHistory> findBySyncJobIdAndStatusAndEventTimeBefore(Long syncJobId, String status, String endTime);

    List<SyncHistory> findBySyncJobIdAndStatusAndEventTimeAfterAndStatus(Long syncJobId, String status, String startTime, String status2);

    List<SyncHistory> findBySyncJobIdAndStatusAndEventTimeBeforeAndStatus(Long syncJobId, String status, String endTime, String status2);

}