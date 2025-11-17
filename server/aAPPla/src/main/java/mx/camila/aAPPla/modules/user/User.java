package mx.camila.aAPPla.modules.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import mx.camila.aAPPla.modules.likes.Likes;
import mx.camila.aAPPla.modules.publication.Publication;

import java.util.List;

@Entity
@Table(name="user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nombre", nullable = false)
    private String nombre;

    @Column(name = "email", nullable = false)
    private String email;

    @JsonIgnore
    @Column(name = "contrasena", nullable = false)
    private String contrasena;

    @Column(name = "status", nullable = false)
    private Boolean status;

    @OneToMany(mappedBy = "user",cascade = CascadeType.PERSIST)
    @JsonIgnore
    private List<Publication> publicaciones;

    @OneToMany(mappedBy = "user", cascade = CascadeType.PERSIST)
    @JsonIgnore
    private List<Likes> likes;

    public List<Likes> getLikes() {
        return likes;
    }

    public void setLikes(List<Likes> likes) {
        this.likes = likes;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public List<Publication> getPublicaciones() {
        return publicaciones;
    }

    public void setPublicaciones(List<Publication> publicaciones) {
        this.publicaciones = publicaciones;
    }

    public User() {
    }

    public User(String nombre, String email, String contrasena, Boolean status) {
        this.nombre = nombre;
        this.email = email;
        this.contrasena = contrasena;
        this.status = status;
    }

    public User(String nombre, String email, String contrasena, Boolean status, List<Publication> publicaciones) {
        this.nombre = nombre;
        this.email = email;
        this.contrasena = contrasena;
        this.status = status;
        this.publicaciones = publicaciones;
    }

    public User(Long id, String nombre, String email, String contrasena, Boolean status, List<Publication> publicaciones, List<Likes> likes) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.contrasena = contrasena;
        this.status = status;
        this.publicaciones = publicaciones;
        this.likes = likes;
    }
}
