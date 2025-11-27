package mx.camila.aAPPla.modules.publication;

import mx.camila.aAPPla.modules.user.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

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

    @PostMapping(value = "", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> addPublication(
            @RequestParam("titulo") String titulo,
            @RequestParam("descripcion") String descripcion,
            @RequestParam("latitud") double latitud,
            @RequestParam("longitud") double longitud,
            @RequestParam("userId") Long userId,
            @RequestPart("imagenes") List<MultipartFile> imagenes
    ) throws IOException {
        PubDTO dto = new PubDTO(titulo, descripcion, latitud, longitud, new User(userId));
        return pubService.addPublication(dto.toEntity(), imagenes);
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
