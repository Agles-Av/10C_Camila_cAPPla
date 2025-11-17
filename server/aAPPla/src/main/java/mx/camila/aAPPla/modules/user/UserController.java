package mx.camila.aAPPla.modules.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
@CrossOrigin("*")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("")
    public ResponseEntity<?> findAll() {
        return userService.getAll();
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@RequestBody UserDTO user, @PathVariable("id") Long id) {
        return userService.update(user.toEntity(), id);
    }

    @PatchMapping("/status/{id}")
    public ResponseEntity<?> changeStatus(@PathVariable("id") Long id) {
        return userService.changeStatus(id);
    }
}
