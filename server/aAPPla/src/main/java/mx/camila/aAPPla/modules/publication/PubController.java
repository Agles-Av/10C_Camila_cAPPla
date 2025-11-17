package mx.camila.aAPPla.modules.publication;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/publication")
@CrossOrigin
public class PubController {
    @Autowired
    private PubService pubService;

    @GetMapping("")
    public ResponseEntity<?> getAlL(){
        return pubService.getAllPublications();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getByUser(@PathVariable("id") Long id){
        return pubService.findByUser(id);
    }

    @PostMapping("")
    public ResponseEntity<?> addPublication(@RequestBody PubDTO pubDTO){
        return pubService.addPublication(pubDTO.toEntity());
    }

    @PatchMapping("/like/{publicationId}/user/{userId}")
    public ResponseEntity<?> addLike(@PathVariable("publicationId") Long publicationId, @PathVariable("userId") Long userId){
        return pubService.addLike(publicationId, userId);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePublication(@RequestBody PubDTO pubDTO, @PathVariable("id") Long id){
        return pubService.updatePublication(pubDTO.toEntity(), id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePublication(@PathVariable("id") Long id){
        return pubService.deletePublication(id);
    }
}
