package mx.camila.aAPPla.modules.publication;

import mx.camila.aAPPla.config.CustomResponse;
import mx.camila.aAPPla.modules.images.Images;
import mx.camila.aAPPla.modules.images.ImagesRepository;
import mx.camila.aAPPla.modules.likes.Likes;
import mx.camila.aAPPla.modules.likes.LikesRepository;
import mx.camila.aAPPla.modules.user.User;
import mx.camila.aAPPla.modules.user.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class PubService {
    @Autowired
    private PubRepository pubRepository;

    @Autowired
    private CustomResponse response;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LikesRepository likesRepository;

    @Autowired
    private ImagesRepository imagesRepository;

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> getAllPublications() {
        return response.getJSONResponse(pubRepository.findAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> addPublication(Publication publication) {
        Publication newPublication = pubRepository.save(publication);
        List<Images> images = publication.getImagenes();
        for (Images image : images) {
            image.setPublication(newPublication);
            imagesRepository.save(image);
        }
        return response.getJSONResponse(newPublication);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> addLike(Long publicationId, Long userId) {
        Optional<Publication> foundPublication = pubRepository.findById(publicationId);
        if (foundPublication.isEmpty()) {
            return response.getBadRequest("Publication not found");
        }
        Publication publication = foundPublication.get();
        List<Likes> existingLikes = likesRepository.findByPublication(publication);

        Optional<User> foundUser = userRepository.findById(userId);
        if (foundUser.isEmpty()) {
            return response.getBadRequest("User not found");
        }
        User user = foundUser.get();
        for (Likes like : existingLikes) {
            if (like.getUser().getId().equals(user.getId())) {
                return response.getBadRequest("User has already liked this publication");
            }
        }
        Likes newLike = new Likes();
        newLike.setPublication(publication);
        newLike.setUser(user);
        likesRepository.save(newLike);
        return response.getJSONResponse("Like added successfully");
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> updatePublication(Publication publication, Long id) {
        Optional<Publication> foundPublication = pubRepository.findById(id);
        if (foundPublication.isEmpty()) {
            return response.getBadRequest("Publication not found");
        }
        Publication existingPublication = foundPublication.get();
        existingPublication.setTitulo(publication.getTitulo());
        existingPublication.setDescripcion(publication.getDescripcion());
        existingPublication.setLongitud(publication.getLongitud());
        existingPublication.setLatitud(publication.getLatitud());
        existingPublication.getImagenes().clear();
        for (Images img : publication.getImagenes()) {
            img.setPublication(existingPublication);
            existingPublication.getImagenes().add(img);
        }

        Publication updatedPublication = pubRepository.save(existingPublication);
        return response.getJSONResponse(updatedPublication);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> findByUser(Long userId) {
        Optional<User> foundUser = userRepository.findById(userId);
        if (foundUser.isEmpty()) {
            return response.getBadRequest("User not found");
        }
        User user = foundUser.get();
        return response.getJSONResponse(pubRepository.findByUser(user));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> deletePublication(Long id) {
        Optional<Publication> foundPublication = pubRepository.findById(id);
        if (foundPublication.isEmpty()) {
            return response.getBadRequest("Publication not found");
        }
        List<Images> images = foundPublication.get().getImagenes();
        for (Images image : images) {
            imagesRepository.deleteById(image.getId());
        }
        pubRepository.deleteById(id);
        return response.getJSONResponse("Publication deleted successfully");
    }
}
