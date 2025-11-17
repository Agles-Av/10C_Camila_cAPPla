package mx.camila.aAPPla.config;

import mx.camila.aAPPla.modules.images.Images;
import mx.camila.aAPPla.modules.images.ImagesRepository;
import mx.camila.aAPPla.modules.likes.Likes;
import mx.camila.aAPPla.modules.likes.LikesRepository;
import mx.camila.aAPPla.modules.publication.PubRepository;
import mx.camila.aAPPla.modules.publication.Publication;
import mx.camila.aAPPla.modules.user.User;
import mx.camila.aAPPla.modules.user.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Configuration
public class InitialConfig implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ImagesRepository imagesRepository;
    private final PubRepository pubRepository;
    private final LikesRepository likesRepository;
    private final PasswordEncoder encoder;

    public InitialConfig(UserRepository userRepository, ImagesRepository imagesRepository, PubRepository pubRepository, LikesRepository likesRepository, PasswordEncoder encoder) {
        this.userRepository = userRepository;
        this.imagesRepository = imagesRepository;
        this.pubRepository = pubRepository;
        this.likesRepository = likesRepository;
        this.encoder = encoder;
    }

    @Transactional
    public User getOrSaveUser(User user) {
        User foundUser = userRepository.findByEmail(user.getEmail());
        if (foundUser != null) {
            return foundUser;
        } else {
            return userRepository.save(user);
        }
    }

    @Transactional
    public Publication getOrSavePublication(Publication publication) {
        Publication foundPublication = pubRepository.findByTitulo(publication.getTitulo());
        if (foundPublication != null) {
            return foundPublication;
        } else {
            for (Images image : publication.getImagenes()) {
                image.setPublication(publication);
            }
            return pubRepository.save(publication);
        }
    }

    @Transactional
    public Images getOrSaveImage(Images image) {
        Images foundImage = imagesRepository.findByUrl(image.getUrl());
        if (foundImage != null) {
            return foundImage;
        } else {
            return imagesRepository.save(image);
        }
    }

    @Transactional
    public Likes getOrSaveLike(Likes like) {
        Likes foundLike = likesRepository.findByUserAndPublication(like.getUser(), like.getPublication());
        if (foundLike != null) {
            return foundLike;
        } else {
            return likesRepository.save(like); // No tocas la lista de la publicación
        }
    }



    @Override
    public void run(String... args) throws Exception {
        User usuario1 = getOrSaveUser(new User("Víctor", "cafatofo@gmail.com", encoder.encode("password123"), true));
        User usuario2 = getOrSaveUser(new User("Agles", "agles@gmail.com", encoder.encode("password123"), true));
        User usuario3 = getOrSaveUser(new User("valentin", "valentin@gmail.com", encoder.encode("password123"), true));

        Images img1 = new Images("https://picsum.photos/id/1/200/300");
        Images img2 = new Images("https://picsum.photos/id/2/200/300");
        Images img3 = new Images("https://picsum.photos/id/3/200/300");
        Images img4 = new Images("https://picsum.photos/id/4/200/300");

        Publication pub1 = new Publication("Primera Publicacion",
                "Esta es la descripcion de la primera publicacion",
                List.of(img1, img2), usuario1, 19.4326f, -99.1332f);

        Publication pub2 = new Publication("Segunda Publicacion",
                "Esta es la descripcion de la segunda publicacion",
                List.of(img3, img4), usuario2, 34.0522f, -118.2437f);

        Publication publication1 = getOrSavePublication(pub1);
        Publication publication2 = getOrSavePublication(pub2);

        Likes like1 = getOrSaveLike(new Likes(publication1, usuario3));
        Likes like2 = getOrSaveLike(new Likes(publication2, usuario1));
    }
}
