package com.ecoleit.hostitauth.repository;

import com.ecoleit.hostitauth.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByName(String name);

    // Add more queries as needed for your application
}
