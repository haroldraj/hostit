package com.ecoleit.hostitauth.repository;

import com.ecoleit.hostitauth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    // You can define other queries as needed, for example:
    // Optional<User> findByEmail(String email);
    // Boolean existsByUsername(String username);
    // Boolean existsByEmail(String email);
}
