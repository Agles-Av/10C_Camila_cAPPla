package mx.camila.aAPPla.modules.images;

import mx.camila.aAPPla.modules.publication.Publication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface ImagesRepository extends JpaRepository<Images, Long> {
    List<Images> findByPublication(Publication publication);

    Images findByUrl(String url);
}
