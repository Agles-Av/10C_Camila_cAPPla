package mx.camila.aAPPla.modules.email;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RecoveryCodeRepository extends JpaRepository<RecoveryCode, Long> {
    Optional<RecoveryCode> findByEmailAndCode(String email, String code);
    Optional<RecoveryCode> findByEmail(String email);
}
