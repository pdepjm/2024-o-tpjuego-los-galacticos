import wollok.game.*
import main.*
import piezasBlancas.*
import reyNegro.*
import spawn.*
import menu.*

object juegoAjedrez2{

  var nroJuego = 1
  var juegoPausado = false
  method estaPausado() = juegoPausado
  var juegoTerminado = false
  method termino() = juegoTerminado

  const listaVisuales = []
  const listaEventos = []
  const listaPersonajes = []
  
  method iniciar(){
    game.height(5)
	  game.width(9)

    game.boardGround("fondo.png")
    menuInicial.agregarMenuInicio()
    juegoPausado = true
    self.inicarTeclasUnicaVez()
    
  }

  method comenzarJuego() {
    juegoPausado = false
    self.agregarPersonaje(reyNegro)
    spawnEnemigo.comenzarSpawn()
    spawnEnemigo.comenzarOleadas()
  }

  method inicarTeclasUnicaVez() {
    if(nroJuego == 1) {
      keyboard.w().onPressDo({reyNegro.moverArriba()})
      keyboard.s().onPressDo({reyNegro.moverAbajo()})
      keyboard.space().onPressDo({if(!juegoPausado && !juegoTerminado) reyNegro.disparar()})
      keyboard.p().onPressDo(
        {
          if(!juegoPausado && !juegoTerminado) {
              self.pausarJuego() 
              pausa.agregarTextoDePausa()
              }
          else if(!menuInicial.estaEnMenu() && !tablaPuntajes.estaEnTabla()) self.reanudarJuego()
        }
      )
      keyboard.r().onPressDo(
        { 
          if(juegoTerminado) {
          reyNegro.reiniciarPersonaje()
          sistemaOleadas.reiniciarOleadas()
          puntajeFinal.sacarPuntajeFinal()
          self.iniciar()
          }  
        }
      )
      keyboard.enter().onPressDo(
        {
          if(menuInicial.estaEnMenu()) {
            menuInicial.sacarMenuInicial()
            self.comenzarJuego()
          }
        }
      )
      keyboard.t().onPressDo(
        {
          if(menuInicial.estaEnMenu()) {
            tablaPuntajes.agregarTablaPuntajes()
          } else if(tablaPuntajes.estaEnTabla()) {
            tablaPuntajes.sacarTablaPuntajes()
          }
        }
      )
      nroJuego += 1
    }
  }

  method agregarPersonaje(personaje) {
    game.addVisualCharacter(personaje)
    listaPersonajes.add(personaje)
  }
  method agregarVisual(visual) {
    game.addVisual(visual)
    listaVisuales.add(visual)
  }
  method agregarEvento(evento) {
    listaEventos.add(evento)
    evento.start()
  }
  method removerVisual(visual) {
    game.removeVisual(visual)
    listaVisuales.remove(visual)
  }
  method removerEvento(evento) {
    evento.stop()
    listaEventos.remove(evento)
  }
  method removerPersonaje(personaje) {
    game.removeVisual(personaje)
    listaPersonajes.remove(personaje)    
  }

  method pausarJuego() { 
      juegoPausado = true
      game.say(self, "Presione P para reanudar el juego")      
  }
  method reanudarJuego() {
      juegoPausado = false
      pausa.quitarTextoPausa()
  }

  method terminarJuego() {
    juegoPausado = true
    listaEventos.forEach({evento => self.removerEvento(evento)})
    listaVisuales.forEach({visual => self.removerVisual(visual)})
    listaPersonajes.forEach({personaje => self.removerPersonaje(personaje)})
    juegoTerminado = true
  }

  // Funcion Test
  method listaVisuales() = listaVisuales 
  
}