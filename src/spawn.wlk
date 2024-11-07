import wollok.game.*
import main.*
import piezasBlancas.*
import reyNegro.*
import juegoAjedrez.*

object spawnEnemigo {
  var oleadaAnterior = null

  method comenzarSpawn() {
    const oleadaInicial = new Tick(interval = 4500, action = {if(!juegoAjedrez2.estaPausado()) self.aparecerPieza()})
    juegoAjedrez2.agregarEvento(oleadaInicial)
    mensajeOleada.mostrarMensajeOleada()
    oleadaAnterior = oleadaInicial
  }

  method comenzarOleadas() {
    const oleadas = new Tick(interval = 30000, action = {
      if(!juegoAjedrez2.estaPausado()) {
      sistemaOleadas.nuevoTiempoSpawn(oleadaAnterior, oleadas)
      mensajeOleada.mostrarMensajeOleada()
      }
    })
    juegoAjedrez2.agregarEvento(oleadas)
  }

  method actualizarOleadaAnterior(nueva) {
      oleadaAnterior = nueva
  }

  method aparecerPieza() {
    // PROBABILIDAD PIEZAS
    // PEON = 30%
    // CABALLO = 20%
    // ALFIL = 20%
    // TORRE = 20%
    // REINA = 10%
    const pieza = [new Peon(), new Peon(), new Peon()
                  , new Caballo(), new Caballo()
                  , new Alfil(), new Alfil() 
                  ,new Torre(), new Torre()
                  ,new Reina()].anyOne()
    juegoAjedrez2.agregarVisual(pieza)
    pieza.empezarMoverse()
  }
}

object sistemaOleadas {
  var nroOleada = 0
  method nroOleada() {
    if(nroOleada != 3) {
      return nroOleada + 1
    } else {
      return "FINAL"
    }
  }
  const listaTiempos = [4000,3000,1000]

  method nuevoTiempoSpawn(oleadaAnterior, eventoOleada) {
    juegoAjedrez2.removerEvento(oleadaAnterior)

    const spawn = new Tick(interval = listaTiempos.get(nroOleada), action = {if(!juegoAjedrez2.estaPausado()) spawnEnemigo.aparecerPieza()})
    juegoAjedrez2.agregarEvento(spawn)

    if(nroOleada != 3) {
      nroOleada += 1 
      spawnEnemigo.actualizarOleadaAnterior(spawn)
    } else {
      juegoAjedrez2.removerEvento(eventoOleada)
    }
  }

  method reiniciarOleadas() {
    nroOleada = 0
  }

}

object mensajeOleada {
  method position() = game.center()
  method text() = "OLEADA " + sistemaOleadas.nroOleada()
  method textColor() = "D02323" 

  method mostrarMensajeOleada() {
    juegoAjedrez2.agregarVisual(self)
    game.schedule(1500, {juegoAjedrez2.removerVisual(self)})
  }

}