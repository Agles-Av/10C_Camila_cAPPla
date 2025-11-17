package mx.camila.aAPPla.modules.user;

import mx.camila.aAPPla.config.CustomResponse;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private CustomResponse customResponse;

    @Autowired
    private UserRepository userRepository;

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> getAll(){
        return customResponse.getJSONResponse(userRepository.findAll());
    }

    @Transactional(rollbackFor = Exception.class)
    public User findByEmail(String email){
        User userFound = userRepository.findByEmail(email);
        if (userFound == null)
            return null;
        return userFound;
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> update(User user, Long id) {
        var foundUser = userRepository.findById(id);
        if (foundUser.isEmpty()) {
            return customResponse.getBadRequest("Usuario no encontrado");
        }
        User existingUser = foundUser.get();
        existingUser.setEmail(user.getEmail());
        existingUser.setNombre(user.getNombre());
        User updatedUser = userRepository.save(existingUser);
        return customResponse.getJSONResponse(updatedUser);
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> changeStatus(Long id) {
        var foundUser = userRepository.findById(id);
        if (foundUser.isEmpty()) {
            return customResponse.getBadRequest("Usuario no encontrado");
        }
        User user = foundUser.get();
        user.setStatus(!user.getStatus());
        User updatedUser = userRepository.save(user);
        return customResponse.getJSONResponse(updatedUser);
    }

}
