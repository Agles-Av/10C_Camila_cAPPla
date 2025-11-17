package mx.camila.aAPPla.modules.publication;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import mx.camila.aAPPla.modules.images.Images;
import mx.camila.aAPPla.modules.likes.Likes;
import mx.camila.aAPPla.modules.user.User;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="publication")
public class Publication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "titulo", nullable = false)
    private String titulo;

    @Column(name = "descripcion", nullable = false, columnDefinition = "TEXT")
    private String descripcion;

    @OneToMany(mappedBy = "publication", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = {"publication"})
    private List<Images> imagenes = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "id_user")
    @JsonIgnoreProperties(value = {"user","publicaciones","status","email"})
    private User user;

    @Column(name = "longitud")
    private Float longitud;

    @Column(name = "latitud")
    private Float latitud;

    @OneToMany(mappedBy = "publication", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = {"publication"})
    private List<Likes> likes = new ArrayList<>();

    public Float getLongitud() {
        return longitud;
    }

    public void setLongitud(Float longitud) {
        this.longitud = longitud;
    }

    public Float getLatitud() {
        return latitud;
    }

    public void setLatitud(Float latitud) {
        this.latitud = latitud;
    }

    public Publication(String titulo, String descripcion, List<Images> imagenes, User user, Float longitud, Float latitud, List<Likes> likes) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.imagenes = imagenes;
        this.user = user;
        this.longitud = longitud;
        this.latitud = latitud;
        this.likes = likes;
    }

    public Publication(String titulo, String descripcion, List<Images> imagenes, User user, Float longitud, Float latitud) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.imagenes = imagenes;
        this.user = user;
        this.longitud = longitud;
        this.latitud = latitud;
    }

    public Publication(Long id, String titulo, String descripcion, List<Images> imagenes, User user, Float longitud, Float latitud, List<Likes> likes) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.imagenes = imagenes;
        this.user = user;
        this.longitud = longitud;
        this.latitud = latitud;
        this.likes = likes;
    }

    public Publication() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public List<Images> getImagenes() {
        return imagenes;
    }

    public void setImagenes(List<Images> imagenes) {
        this.imagenes = imagenes;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Likes> getLikes() {
        return likes;
    }

    public void setLikes(List<Likes> likes) {
        this.likes = likes;
    }
}
