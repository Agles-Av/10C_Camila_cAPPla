package mx.camila.aAPPla.modules.publication;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import mx.camila.aAPPla.modules.images.Images;
import mx.camila.aAPPla.modules.likes.Likes;
import mx.camila.aAPPla.modules.user.User;

import java.util.List;

public class PubDTO {
    private Long id;
    private String titulo;
    private String descripcion;
    private List<Images> imagenes;
    private User user;
    private Float longitud;
    private Float latitud;

    public Publication toEntity(){
        return new Publication(titulo, descripcion, imagenes, user, longitud, latitud);
    }

    public PubDTO() {
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
}
