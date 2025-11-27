package mx.camila.aAPPla.modules.publication;

import mx.camila.aAPPla.modules.user.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PubRepository extends JpaRepository<Publication, Long> {
    List<Publication> findByUser(User user);

    // este solo es pal initial config
    Publication findByTitulo(String titulo);

    // ultimas adiciones primero
    List<Publication> findAllByOrderByIdDesc();
}
