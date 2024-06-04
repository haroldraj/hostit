package com.ecoleit.hostitanalytics.repository;

import com.ecoleit.hostitanalytics.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // You can add custom database queries here if needed

    // Example custom query to find a user by email
    User findByEmail(String email);
}
