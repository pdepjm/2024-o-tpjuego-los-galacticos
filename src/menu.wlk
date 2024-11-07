import wollok.game.*
import main.*
import piezasBlancas.*
import reyNegro.*
import spawn.*
import juegoAjedrez.*

class Texto {
  const posicion = game.center()
  const color = "D02323"
  const texto

  method position() = posicion
  method textColor() = color
  method text() = texto
}

object menuInicial {
  var estaEnMenu = false
  method estaEnMenu() = estaEnMenu 
  const filaUno = new Texto(texto = "ENTER PARA EMPEZAR")
  const filaDos = new Texto(texto = "T PARA VER TABLA DE PUNTOS", posicion = game.at(4,game.center().y()-1))

  method agregarMenuInicio() {
    juegoAjedrez2.agregarVisual(filaUno)
    juegoAjedrez2.agregarVisual(filaDos)
    estaEnMenu = true
  }
  method sacarMenuInicial() {
    juegoAjedrez2.removerVisual(filaUno)
    juegoAjedrez2.removerVisual(filaDos)
    estaEnMenu = false
  }
}

object tablaPuntajes {
  var estaEnTabla = false
  method estaEnTabla() = estaEnTabla
  const tablaPuntos = [0,0,0]
  var filaUno = new Texto(texto = "1ro ~~~ " + tablaPuntos.get(0) + " PUNTOS", posicion = game.at(4,game.center().y() + 1))
  var filaDos = new Texto(texto = "2do ~~~ " + tablaPuntos.get(1) + " PUNTOS")
  var filaTres = new Texto(texto = "3ro ~~~ " + tablaPuntos.get(2) + " PUNTOS", posicion = game.at(4,game.center().y() - 1))
  const filaCuatro = new Texto(texto = "PRESIONE T PARA VOLVER AL MENU INICIAL", posicion = game.at(4,0))

  method actualizarTabla(puntaje) {
    if(tablaPuntos.size() < 3) {
      self.agregarATabla(puntaje)
    } else if(tablaPuntos.last() < puntaje) {
      tablaPuntos.remove(tablaPuntos.last())
      self.agregarATabla(puntaje)
    } 
  }
  method agregarATabla(puntaje) {
    tablaPuntos.add(puntaje)
    tablaPuntos.sortBy({a,b => a > b})
    filaUno = new Texto(texto = "1ro ~~~ " + tablaPuntos.get(0) + " PUNTOS", posicion = game.at(4,game.center().y() + 1))
    filaDos = new Texto(texto = "2do ~~~ " + tablaPuntos.get(1) + " PUNTOS")
    filaTres = new Texto(texto = "3ro ~~~ " + tablaPuntos.get(2) + " PUNTOS", posicion = game.at(4,game.center().y() - 1))
  }
  
  method agregarTablaPuntajes() {
    menuInicial.sacarMenuInicial()
    juegoAjedrez2.agregarVisual(filaUno)
    juegoAjedrez2.agregarVisual(filaDos)
    juegoAjedrez2.agregarVisual(filaTres)
    juegoAjedrez2.agregarVisual(filaCuatro)
    estaEnTabla = true
  }
  method sacarTablaPuntajes() {
    estaEnTabla = false
    juegoAjedrez2.removerVisual(filaUno)
    juegoAjedrez2.removerVisual(filaDos)
    juegoAjedrez2.removerVisual(filaTres)
    juegoAjedrez2.removerVisual(filaCuatro)
    menuInicial.agregarMenuInicio()
  }
}


object puntajeFinal {
  var puntaje = 0
  var filaUno = new Texto(texto = "EL PUNTAJE FUE DE " + puntaje + " PUNTOS")
  const filaDos = new Texto(texto = "PRESIONE R PARA VOLVER AL MENU INICIAL", posicion = game.at(4,game.center().y()-1))

  method actualizarPuntaje() {
    puntaje = reyNegro.puntaje()
    filaUno = new Texto(texto = "EL PUNTAJE FUE DE " + puntaje + " PUNTOS")
    tablaPuntajes.actualizarTabla(puntaje)    
  }
  method agregarPuntajeFinal() {
    juegoAjedrez2.agregarVisual(filaUno)
    juegoAjedrez2.agregarVisual(filaDos)
  }
  method terminarJuego() {
    self.actualizarPuntaje()
    juegoAjedrez2.terminarJuego()
    self.agregarPuntajeFinal()
  }
  method sacarPuntajeFinal() {
    juegoAjedrez2.removerVisual(filaUno)
    juegoAjedrez2.removerVisual(filaDos)
  }
}

object pausa{
  method position() = game.center()
  method text() = "ESTAS EN PAUSA, PRESIONE P PARA SEGUIR JUGANDO"
  method textColor() = "D02323"
  
  method agregarTextoDePausa() {
    juegoAjedrez2.agregarVisual(self)
  }
  method quitarTextoPausa() {
    juegoAjedrez2.removerVisual(self)
  }
}