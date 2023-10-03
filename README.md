# PC1
***
## Integrantes
- Juan de Dios Fernando Lerzundi Ríos
- José Daniel Zapata Anco
- Omar Baldomero Vite Allca
- Daniel Ureta Espinal
***
## Introducción
**Objetivo**
Comprender los pasos necesarios para crear, versionar e implementar una aplicación SaaS, incluido el seguimiento de las librerías de las que depende para que sus entornos de producción y desarrollo sean lo más similares posible.

**Creación y Versionado de una aplicación SaaS**
- Crear un nuevo directorio y versionarlo con git
```bash
git init
```
- Crear un nuevo archivo llamado `Gemfile`
  ```Ruby
  source 'https://rubygems.org'
  ruby '2.6.6'
  gem 'sinatra', '>= 2.0.1'
  ```
- Ejecuta el comando `bundle` que examina tu `Gemfile`
```bash
bundle install
```
***
**¿Cuál es la diferencia entre el propósito y el contenido de `Gemfile` y `Gemfile.lock`?**

En estos archivos es donde se encuentran las dependencias, el principal propósito tanto de Gemfile como de Gemfile.lock es asegurar la consistencia en las versiones de las dependencias y proporcionar un entorno de desarrollo coherente.

**¿Qué archivo se necesita para reproducir completamente las gemas del entorno de desarrollo en el entorno de producción?**

Para reproducir en su totalidad las gemas necesitamos del archivo Gemfile.lock en el que se especifican detalladamente las dependencias y es el encargado junto a bundle de instalar las mismas versiones de las gemas en el servidor de producción.

**Después de ejecutar el bundle, ¿Por qué aparecen gemas en `Gemfile.lock` que no estaban en `Gemfile`?**

Esto generalmente sucede por que algunas gemas tienen subdependencias las cuales tambien son instaladas indirectamente por bundle. Como en nuestro ejemplo rack es una dependencia de sinatra mas no vemos rack en nuestro gemfile.


***
- Crea un archivo en tu proyecto llamado `app.rb` que contenga lo siguiente:
```Ruby
require 'sinatra'

class MyApp < Sinatra::Base
    get '/' do
        "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
    end
end
```
Para ejecutar la aplicación, tenemos que iniciar el servidor de aplicaciones y el servidor de nivel de presentación (web). El servidor de aplicaciones en rack está controlado por un archivo `config.ru`, que ahora debe crear y agregar al control de versiones, y que contiene lo siguiente:
```Ruby
require './app'

run MyApp
```
- Iniciamos el servidor de aplicaciones Rack y el servidor web WEBrick
```shell
bundle exec rackup --port 3000
```
***
**¿Qué sucede si intentas visitar una URL no raíz cómo https://localhost:3000/hello y por qué la raíz de tu URL variará?**

Al intentar vistar https://localhost:3000/hello estoy accediendo a la ruta '/hello' la cual no ha sido definida en el código, solo la ruta raiz '/':
```Ruby
get '/' do
  "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
end
```
***
- Modifica app.rb para que en lugar de "Hello world" imprime "Goodbye world"
>Si modificas tu aplicación mientras se está ejecutando, debes reiniciar 
Rack para que "veas" esos cambios
- Usaremos la gema de `rerun`, que reinicia Rack automáticamente cuando ve cambios en los archivos en el directorio de la aplicación.
-  Agrega lo siguiente al Gemfile:
```Ruby
group :development do
  gem 'rerun'
end
```
***
## Parte 1: Wordguesser
Con toda esta maquinaria en mente, clona este repositorio y trabajemos el juego de adivinar palabras (Wordguesser).
```bash
git clone https://github.com/saasbook/hw-sinatra-saas-wordguesser

cd hw-sinatra-saas-wordguesser

bundle
```
- Clonamos el repositorio correctamente

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/168a5c51-e192-41bd-a63b-70379978c80a)

- Instalamos todas las gemas faltantes

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/44f31a1a-c2a7-4799-b6df-4085dfadaf76)

Instalamos todas las gemas faltantes

En el directorio raíz de la aplicación, escribe `bundle exec autotest`

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/f8ab2131-9a3b-4ed3-bf8a-db61d58c2e6b)

Ahora, con Autotest aun ejecutándose, elimina `:pending => true` y guarde el archivo. Deberías ver inmediatamente que Autotest se activa y vuelve a ejecutar las pruebas. Ahora debería tener 18 ejemplos, 1 fallido y 17 pendientes

Eliminamos :pending => true en cada especificacion (spec)

```ruby
  describe 'new' , :pending => true do
    it "takess a parameter and returns a WordGuesserGame object" do      
      @game = WordGuesserGame.new('glorp')
      expect(@game).to be_an_instance_of(WordGuesserGame)
      expect(@game.word).to eq('glorp')
      expect(@game.guesses).to eq('')
      expect(@game.wrong_guesses).to eq('')
    end
  end

```
***
## Parte 2: RESTful para Wordguesser
***
## Parte 3: Conexión de WordGuesserGame a Sinatra
***
## Parte 4: Cucumber
Cucumber es una herramienta extraordinaria para redactar pruebas de aceptación e integración de alto nivel.

**¿Qué pasos utiliza Capybara para simular el servidor como lo haría un navegador y para inspeccionar la respuesta de la aplicación al estímulo?**
1. Inicia el servidor de pruebas con webrick
2. Emula la interacción del usuario
3. Visita la URL con `visit 'url'`
4. Interactua con la página mediante métodos como `click_link` , `click_button`, `fill_in`
5. Esperas explicitas que determinan cuando realizar acciones `expect(page).to have_content 'Success'`
6. Cierre del navegador y limpieza de cualquier estado alterado

**Mirando features/guess.feature, ¿Cuál es la función de las tres líneas que siguen al encabezado "Feature:"?**

- `As a player playing Wordguesser`
Describe el rol del usuario o del actor que está interactuando con el juego wordguesser
- `So that I can make progress toward the goal`
Esta línea explica el por qué esta funcionalidad es importante desde el punto de vista del usuario.
- `I want to see when my guess is correct`
Especifica lo que se desea visualizar al finalizar el intento de adivinanza.

**Observando el paso del escenario Given I start a new game with word "garply" qué líneas en game_steps.rb se invocarán cuando Cucumber intente ejecutar este paso y cuál es el papel de la cadena "garply" en el paso?**

En el escenario dado
```
Given I start a new game with word "garply"
```
Las siguientes lineas son las que se invocarán cuando Cucumber trate de ejecutar este paso por que la cadena "garply" es un parámetro capturado por el grupo de captura (.*) en la expresión regular asociada con el paso. 
```Ruby
When /^I start a new game with word "(.*)"$/ do |word|
  stub_request(:post, "http://randomword.saasbook.info/RandomWord").
    to_return(:status => 200, :headers => {}, :body => word)
  visit '/new'
  click_button "New Game"
end
```
La variable word se utiliza para capturar y almacenar la palabra proporcionada en el escenario para que pueda ser utilizada en la simulación de la respuesta del servidor y en la configuración del juego en la prueba de Cucumber.
 
**Cuando el "simulador de navegador" en Capybara emite la solicitud de visit '/new', Capybara realizará un HTTP GET a la URL parcial /new en la aplicación. ¿Por qué crees que visit siempre realiza un GET, en lugar de dar la opción de realizar un GET o un POST en un paso determinado?**

Las pruebas de integración, incluidas las pruebas de comportamiento, están diseñadas para probar la aplicación desde la perspectiva del usuario final. En este contexto, las acciones del usuario, como hacer clic en enlaces, enviar formularios y escribir en la barra de direcciones del navegador, se modelan a través de solicitudes HTTP GET. Cuando un usuario normalmente visita una página web, lo hace utilizando un GET para recuperar recursos y mostrar información en el navegador.

>Al evitar solicitudes POST directas en las pruebas de comportamiento, se mantiene un enfoque más observacional y menos manipulativo en las pruebas.

Ejecutamos el escenario de "new game" con:

```shell
cucumber features/start_new_game.feature
```
Nos da como resultado:

```shell
Feature: start new game
  As a player
  So I can play Wordguesser
  I want to start a new game

  Scenario: I start a new game         # features/start_new_game.feature:7
    Given I am on the home page        # features/step_definitions/game_steps.rb:61
    And I press "New Game"             # features/step_definitions/game_steps.rb:74
    Then I should see "Guess a letter" # features/step_definitions/game_steps.rb:70
      expected to find text "Guess a letter" in "Not Found" (RSpec::Expectations::ExpectationNotMetError)      
      ./features/step_definitions/game_steps.rb:71:in `/^(?:|I )should see "([^\"]*)"(?: within "([^\"]*)")?$/'
      features/start_new_game.feature:11:in `I should see "Guess a letter"'
    And I press "New Game"             # features/step_definitions/game_steps.rb:74
    Then I should see "Guess a letter" # features/step_definitions/game_steps.rb:70

Failing Scenarios:
cucumber features/start_new_game.feature:7 # Scenario: I start a new game

1 scenario (1 failed)
5 steps (1 failed, 2 skipped, 2 passed)
```

El escenario falla porque la etiqueta `form` en views/new.erb es incorrecta y está incompleta en la información que le dice al navegador en qué URL publicar el formulario por lo que la solución sería

```Ruby
<form action="/create" method="post">
  <div class="form-row py-3 border-top">
    <input type="submit" value="New Game" class="col-md-2 offset-md-5 btn btn-primary form-control"/>
  </div>
</form>
```
**¿Cuál es el significado de usar Given versus When versus Them en el archivo de características? ¿Qué pasa si los cambias? Realiza un experimento sencillo para averiguarlo y luego confirme los resultados utilizando Google.**
- Given: Esta palabra clave se utiliza para establecer el estado inicial del escenario. Especifica las condiciones previas para realizar las acciones del escenario. 

- When: La palabra clave When se utiliza para describir la acción o el evento que desencadena el escenario. Representa la acción que el usuario realiza.

- Then: La palabra clave Then se utiliza para describir el resultado o la consecuencia esperada después de que se haya realizado la acción especificada en la sección When.

**En game_steps.rb, mira el código del paso "I start a new game..." y, en particular, el comando stub_request. Dada la pista de que ese comando lo proporciona una gema (biblioteca) llamada webmock, ¿Qué sucede con esa línea y por qué es necesaria?.**

Es utilizada para simular solicitudes HTTP durante las pruebas. Esta gema te permite simular el comportamiento de las solicitudes HTTP sin realizar realmente peticiones a un servidor externo. En otras palabras, puedes "fingir" que una solicitud real ha ocurrido y definir cómo debería comportarse el servidor en respuesta a esa solicitud simulada. 

Cuando se hace esta solicitud simulada, en lugar de realizar una solicitud real a esa URL, WebMock intercepta la solicitud y devuelve la respuesta especificada en `to_return(:status => 200, :headers => {}, :body => word)`.

**En tu código Sinatra para procesar una adivinación, ¿qué expresión usaría para extraer 'solo el primer carácter' de lo que el usuario escribió en el campo de adivinación de letras del formulario en show.erb?**

/^./ Es la expresión regular que devuelve el primer caracter o también convertirlo a string y llamar al primer elemento

En el código guess en el archivo Sinatra app.rb, debes:
- Extrae la letra enviada en el formulario. (dado arriba y en el código)
- Utiliza esa letra para adivinar el juego actual. (agrega este código)
- Redirige a la acción show para que el jugador pueda ver el resultado de su adivinación. 

```Ruby
post '/guess' do
    letter = params[:guess].to_s[0]
    if @game.guess(letter)
      redirect '/show'
    else
      flash[:message] = "Invalid guess."
      redirect '/show'
    end
  end
```
Verificamos que todos los pasos en feature/guess.feature pasen ejecutandose cucumber
```shell
cucumber features/guess.feature
```
***
## Parte 5: Otros casos
Utilizaremos este proceso para desarrollar el código para las acciones restantes, win y lose.

1. Escoge un nuevo escenario para trabajar
2. Ejecuta el escenario y observa cómo falla
3. Desarrollar código que haga pasar cada paso del escenario.
4. Repita hasta que pasen todos los pasos.

**Cheating Feature / Scenarios**

- Navigate to lose page
- Navigate to win page

Para evitar que el usuario haga trampas simplemente visitando GET/win vamos a crear un estado que indica si el juego ha terminado o no. Entonces modificamos el archivo app.rb

```Ruby
before do
  @game = session[:game] || WordGuesserGame.new('')
  @game_over = false
end
```

Ahora nos aseguramos que en caso se gane o se pierda la partida el juego sea terminado

```Ruby
  get '/show' do
    if @game.check_win_or_lose == :win
      @game_over = true
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      @game_over = true
      redirect '/lose'
    else
      erb :show
    end
  end
```
Modificamos los métodos GET/win y GET/lose para evitar trampas por parte del usuario
```Ruby
  get '/win' do
    if @game_over == false
      flash[:message] = "No hagas trampa :3"
      redirect '/show'
    end
    erb :win
  end
  
  get '/lose' do
    if @game_over == false
      redirect '/show'
    end
    erb :lose
  end
```

**Repeated Guess Feature / Scenarios**

- Guess correct letter that I have already tried
- Guess incorrect letter that I have already tried
- Guessing an incorrect letter does not count towards guesses

```Ruby
  post '/guess' do
    letter = params[:guess].to_s[0]
    if @game.guess(letter)
      redirect '/show'
    else
      flash[:message] = "You have already used that letter"
      redirect '/show'
    end
  end
```

**Invalid Guess Feature / Scenarios**

- Guess an empty guess
- Guess a noncharacter guess

```Ruby
  post '/guess' do
    letter = params[:guess].to_s[0]
    if letter.nil? || letter.empty? || !letter.match?(/[A-Za-z]/)
      flash[:message] = "Invalid guess."
    elsif @game.guess(letter)
      redirect '/show'
    else
      flash[:message] = "You have already used that letter"
      redirect '/show'
    end
  end
```

