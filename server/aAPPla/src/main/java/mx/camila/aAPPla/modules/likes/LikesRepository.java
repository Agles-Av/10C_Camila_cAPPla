package mx.camila.aAPPla.modules.likes;

import mx.camila.aAPPla.modules.publication.Publication;
import mx.camila.aAPPla.modules.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LikesRepository extends JpaRepository<Likes, Long> {
    List<Likes> findByPublication(Publication publication);
    Likes findByUserAndPublication(User user, Publication publication);
}
