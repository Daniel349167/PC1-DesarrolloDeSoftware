# PRESENTACION
[![Presentacion]({https://unipe-my.sharepoint.com/:i:/g/personal/juan_lerzundi_r_uni_pe/EZ4_ncTZoUVBoZdcAnVi2GUBcRjsvvC2MvWYjEDHZ6KhHA?e=pXvKdd})](https://drive.google.com/file/d/1BLUNBG8KkMiUtJP4BhUlQYOFxSzOO9MY/view?usp=sharing&classId=a1bdca4c-128c-4417-a816-076ce4107fd5&assignmentId=19829fd2-e636-4bd7-a6be-f40123f620ff&submissionId=d90d1f1a-8eff-67e2-566a-ae57bc160f6d)
***
# PC1
***
## Integrantes
- Juan de Dios Fernando Lerzundi Ríos
- José Daniel Zapata Ancco
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
**1. ¿Cuál es la diferencia entre el propósito y el contenido de `Gemfile` y `Gemfile.lock`?**

El Gemfile especifica las gemas y versiones que el proyecto requiere, definiendo las dependencias de alto nivel. Por otro lado, el Gemfile.lock detalla las versiones exactas de esas gemas y todas sus subdependencias, con el propósito de asegurar que se use la misma versión de cada gema en todos los entornos, garantizando así una consistencia en el proyecto.

**2. ¿Qué archivo se necesita para reproducir completamente las gemas del entorno de desarrollo en el entorno de producción?**

Para reproducir en su totalidad las gemas necesitamos del archivo Gemfile.lock en el que se especifican detalladamente las dependencias y es el encargado junto a bundle de instalar las mismas versiones de las gemas en el servidor de producción.

**3. Después de ejecutar el bundle, ¿Por qué aparecen gemas en `Gemfile.lock` que no estaban en `Gemfile`?**

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
- Para ejecutar la aplicación, necesitamos iniciar un servidor que pueda manejar tanto las solicitudes web como la ejecución de nuestra aplicación Ruby. Utilizaremos rackup, que por defecto inicia el servidor WEBrick y lo configura para ejecutar aplicaciones basadas en la interfaz Rack.

El comportamiento de nuestra aplicación está definido en el archivo config.ru, que contiene lo siguiente:
```Ruby
require './app'

run MyApp
```
- Para poner en marcha tu aplicación web utilizando el servidor WEBrick, ejecuta:
```shell
bundle exec rackup --port 3000
```
***
**4. ¿Qué sucede si intentas visitar una URL no raíz cómo https://localhost:3000/hello y por qué la raíz de tu URL variará?**

Al acceder a https://localhost:3000/hello, recibirás un error indicando que la ruta no fue encontrada. Esto se debe a que en el código sólo se ha definido una acción para la ruta raíz ('/'). La ruta /hello no ha sido especificada en el código, por lo que Sinatra no sabe cómo manejar esa solicitud y, como resultado, devuelve un error "Not Found" (No Encontrado)

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
-  Ejecuta `bundle install`.
Para iniciar tu aplicación y comprobar que está ejecutándose con reinicio automático, usa el siguiente comando:
```shell
bundle exec rerun -- rackup --port 3000
```
- Haz modificaciones en app.rb y refresca la pestaña del navegador donde se está ejecutando tu aplicación para ver los cambios en tiempo real.
***
**Despliegue en Heroku**
- Instala Heroku CLI y accede a tu cuenta: 
```shell
heroku login -i
```
- En el directorio raíz de tu proyecto, crea un nuevo proyecto en Heroku:
```shell
heroku create
```
- Crea un Procfile para decirle a Heroku cómo iniciar tu aplicación. Añade la siguiente línea:
```shell
web: bundle exec rackup config.ru -p $PORT
```
- Ahora estás listo para desplegar en Heroku:
```shell
git push heroku master
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
....
Continúa el código
....
```
Inmediatamente Autotest reacciona y nos ejecuta esto:

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/82155eea-866e-4418-81f5-54e7060fb8ab)


El bloque describe ‘new’ significa "el siguiente bloque de pruebas describe el comportamiento de una 'nueva' instancia de WordGuesserGame". La línea WordGuesserGame.new hace que se cree una nueva instancia y las siguientes líneas verifican la presencia y los valores de las variables de instancia. 

***
**Preguntas** 

Según los casos de prueba, ¿cuántos argumentos espera el constructor de la clase de juegos (identifica la clase) y, por lo tanto, cómo será la primera línea de la definición del método que debes agregar a wordguesser_game.rb? 

El constructor de la clase WordGuesserGame no espera ningún argumento, ya que en la prueba de "new", se crea una nueva instancia de WordGuesserGame de la siguiente manera: 

```ruby
@game = WordGuesserGame.new('glorp')
```

Sin embargo, para que el constructor no espere ningún argumento, se debe modificar la definición del constructor en el archivo wordguesser_game.rb: 

```ruby
def initialize 

  # Código para inicializar las variables de instancia 

end 
```
Esto garantiza que el constructor no espere ningún argumento al crear una nueva instancia de WordGuesserGame. 

 ***

**Según las pruebas de este bloque describe, ¿qué variables de instancia se espera que tenga WordGuesserGame?**

Se espera que las variables de instancia @word, @guesses, y @wrong_guesses existan y estén inicializadas correctamente cuando se crea una nueva instancia de WordGuesserGame. 
***
Depuración

Ejecutamos este comando para verificar si está recibiendo palabras aleatorias:
```bash
$ curl --data '' http://randomword.saasbook.info/RandomWord
```
Lo ejecutamos 3 veces y obtenemos las palabras furniture, mountain y uncovered. Lo cual significa que funciona perfectamente.

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/e395b849-89e6-41c3-a06c-615fac157be2)

***
## Parte 2: RESTful para Wordguesser
Wordguesser siguiendo los principios RESTful, la aplicación utilizará rutas y solicitudes HTTP (como GET, POST, PUT, DELETE) de una manera coherente y predecible para realizar operaciones en recursos específicos, como palabras, usuarios, juegos, etc.
***
**1. ¿Cuál es el estado total necesario para que la siguiente solicitud HTTP continúe el juego donde lo dejó la solicitud anterior?**

En nuestra aplicación, el estado total necesario para continuar el juego se almacena en una instancia de la clase WordGuesserGame, que es la representación del juego. Esta instancia se almacena en la sesión del usuario para que pueda ser accedida en diferentes solicitudes HTTP. Los elementos clave de estado incluyen la palabra a adivinar, las letras adivinadas correctamente, las letras adivinadas incorrectamente y el estado actual del juego (ganar, perder o jugar). 
***
**2. ¿Cuáles son las diferentes acciones del juego y cómo deberían corresponderse las solicitudes HTTP con esas acciones?** 

GET /new: Inicia un nuevo juego. Cuando un usuario accede a esta ruta, se crea una nueva instancia de WordGuesserGame, y la información de este juego se almacena en la sesión del usuario. Esto se maneja en la acción get '/new'. 

```ruby
  get '/new' do
    erb :new
  end
```
POST /create: Permite al usuario ingresar una palabra para adivinar o generar una palabra aleatoria. La acción post '/create' toma la palabra ingresada o generada y crea una nueva instancia del juego con esa palabra. 
```ruby
  post '/create' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
```
POST /guess: Permite al usuario adivinar una letra. Cuando se envía un formulario de adivinanza, la acción post '/guess' recibe la letra adivinada y la agrega al juego. Dependiendo de si la suposición es correcta o incorrecta, se redirige al usuario a la vista correspondiente. 
```ruby
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
GET /show: Muestra el estado actual del juego. Cuando un usuario accede a esta ruta, se verifica si el juego está en curso, ganado o perdido, y se muestra la vista correspondiente con la información actual del juego. 
```ruby
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
GET /win: Muestra la página de victoria. Cuando el juego se gana, se redirige al usuario a esta vista para mostrar que ha ganado el juego. 
```ruby
  get '/win' do
    if @game_over == false
      flash[:message] = "No hagas trampa :3"
      redirect '/show'
    end
    erb :win
  end
```
GET /lose: Muestra la página de derrota. Cuando el juego se pierde, se redirige al usuario a esta vista para mostrar que ha perdido el juego. 
```ruby
  get '/lose' do
    if @game_over == false
      redirect '/show'
    end
    erb :lose
  end
end
```
***

En aplicaciones web basadas en SaaS (Software as a Service), se utiliza comúnmente una cookie como mecanismo para mantener el estado entre el navegador del usuario y el servidor. Una cookie es un pequeño fragmento de información que el servidor puede almacenar en el navegador del usuario y que el navegador promete enviar de vuelta al servidor en cada solicitud subsiguiente. Cada usuario tiene su propia cookie, lo que permite mantener el estado de forma efectiva para cada usuario.

**Pregunta Enumera el estado mínimo del juego que se debe mantener durante una partida de Wordguesser.**

- El estado mínimo del juego que se debe mantener durante una partida de Wordguesser incluye: 

- La palabra a adivinar: Es esencial mantener un registro de la palabra que el jugador debe adivinar. Esta palabra puede ser almacenada como una cadena de caracteres. 

- Las letras adivinadas correctamente: Se necesita un registro de las letras que el jugador ha adivinado correctamente en la palabra. Esto se puede mantener como una cadena de caracteres o una lista de letras. 

- Las letras adivinadas incorrectamente: Debe llevarse un registro de las letras que el jugador ha adivinado incorrectamente en la palabra. Esto también se puede mantener como una cadena de caracteres o una lista de letras. 

- El estado actual del juego: Es necesario conocer el estado actual del juego para determinar si el jugador ha ganado, perdido o si el juego está en curso. Esto podría representarse como un valor o una variable que indica si el juego está en curso, ganado o perdido. 

***
**El juego como recurso RESTful**

Pregunta 

**Enumera las acciones del jugador que podrían provocar cambios en el estado del juego.**

1. Iniciar un nuevo juego.
   
   ![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/07d57266-a3f2-431b-a792-53ffe7354bc3)

2. Realizar una suposición.
   
![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/bac8271b-d744-4256-bdc5-614e9ac13487)

3. Ver el estado actual del juego. 

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/f75c0d7b-67f2-4806-98ad-48d504271c83)

4. Ganar el juego.

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/68f8c867-a118-4233-bbc5-075e356cc491)

5. Perder el juego.

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/7fbcda80-c102-4ac9-8783-e1fa2b123d8c)


***
Pregunta 

**Para un buen diseño RESTful, ¿cuáles de las operaciones de recursos deberían ser manejadas por HTTP GET y cuáles deberían ser manejadas por HTTP POST?**

HTTP GET: La operación "show" podría ser manejada por HTTP GET, ya que solo muestra el estado actual del juego sin realizar cambios en él. 

HTTP POST: Las operaciones "create" y "guess" deberían ser manejadas por HTTP POST, ya que crean un nuevo juego o realizan una suposición que afecta el estado del juego. 

Este diseño sigue los principios RESTful de usar HTTP GET para operaciones de lectura y HTTP POST para operaciones que cambian el estado del recurso. 
***
Preguntas 

**¿Por qué es apropiado que la nueva acción utilice GET en lugar de POST?**
**Explica por qué la acción GET /new no sería necesaria si tu juego Wordguesser fuera llamado como un servicio en una verdadera arquitectura orientada a servicios.**

En el contexto de una acción "new" que crea un nuevo juego, es apropiado que utilice la solicitud HTTP GET en lugar de POST debido a la diferencia en la naturaleza de estas dos solicitudes HTTP: 

En un juego como Wordguesser, la creación de un nuevo juego podría no requerir una ruta /new como en una aplicación monolítica. En lugar de eso, en una arquitectura orientada a servicios, podrías tener un servicio independiente llamado "GameService" que se encargue de la gestión de juegos. Los clientes que deseen iniciar un nuevo juego podrían enviar una solicitud a este servicio, que podría ser una operación POST en una ruta como /games.

GET se utiliza comúnmente para solicitar recursos o información del servidor sin modificar los datos en el servidor. En este caso, la acción "new" simplemente está solicitando la creación de un nuevo juego sin enviar datos que deban procesarse en el servidor. Es una solicitud segura e idempotente que no cambia el estado del servidor. 

POST, por otro lado, se usa típicamente para enviar datos al servidor para su procesamiento y posiblemente modificar el estado del servidor. Usar POST para la acción "new" podría llevar a la creación accidental de múltiples juegos si el usuario actualiza la página después de enviar el formulario de creación. Además, podría generar problemas de seguridad si el juego se crea cada vez que se realiza una solicitud POST sin autenticación. 
***

## Parte 3: Conexión de WordGuesserGame a Sinatra
Luego de haber establecido los principales estados del juego pasaremos a la
implementación de la app en el navegador. Es en este paso en el que veremos
el primer prototipo funcional del programa.

* Usamos `before do...end` y `after do...end` para ejecutar un bloque de código
  antes y después de cada solicitud.

Adicionalmente, las variables de instancia que hayan sido definidas
dentro de estos filtros podrán ser usadas por **rutas** y **plantillas**.
```Ruby
before do
  @note = 'Hi!'
  request.path_info = '/foo/bar/baz'
end

get '/foo/*' do
  @note #=> 'Hi!'
  params['splat'] #=> 'bar/baz'
end
```
Estos filtros se ejecutan en el mismo contexto
de las rutas que preceden y pueden modificar la solicitud y su respuesta.

Los filtros `after do`, que son evaluados después de cada solicitud
, pueden acceder a las variables de instancia definidas en rutas o en
filtros `before do`
```Ruby
after do
  puts response.status
end
```

* Las llamadas `erb : action` son las que nos permitirán trasladar
  nuestra app al navegador a través de llamadas a plantillas o vistas.
```Ruby
get '/' do
  erb :index
end
#Llamada a la plantilla :index dentro de views/
```
Luego de llamar a `erb : action` Sinatra buscará en los archivos
`.erb` de la carpeta `/views` la acción correspondiente y , a través del procesador
Ruby integrado, buscará construcciones del tipo `<%= like this%>` y
ejecutará el comando que está adentro.

* También podemos pasar el contenido de la plantilla directamente.

```Ruby
get '/' do
  code = "<%= Time.now %>"
  erb code
end
```
***
En `app.rb` usamos `before do` y `after do` para almacenar el estado del
juego al momento de empezar y luego de cada solicitud para actulizarlo.


```Ruby
before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
after do
  session[:game] = @game
end
```

**¿@game en este contexto es una variable de instancia de qué clase?**

`De la clase WordGuesserGame.`

![img_4.png](https://user-images.githubusercontent.com/59848543/273352986-6f1d8950-dd12-4f6d-b8a6-effb327f1511.png)

***
### La sesión

Luego de establecer los estados necesarios para mantener el
estado del juego y encapsularlos en la clase
`WordGuesserGame`, necesitamos llevar la cuenta del
estado del juego entre cada solicitud, al comienzo
y al final de este. 

Dado que nuestro juego es muy pequeño podemos
evitar el implementar una base de datos para registrar
los distintos estados del juego y en su lugar
podemos usar el hash `session[]` de la librería **Sinatra**. 

![img_6.png](https://user-images.githubusercontent.com/59848543/273352990-530f8f63-5b9f-4edd-b107-f55a6e2a8d2a.png)

Ahora podemos almacenar estados del juego que estén disponibles
para cada solicitud. 

Adicionalmente, aparte de los estados del juego,
también queremos proporcionar mensajes para acciones importantes
del juego como mostrar un mensaje que diga "Adivinación Incorrecta",

Para este caso usaremos el hash `flash[]` también de la librería **Sinatra**.
Este hash emula el comportamiento del hash `flash[]` de **Rails**, nos permite 
nos permite compartir mensajes entre acciones. El valor que pasemos
a `flash[]` estará disponible para la siguiente solicitud y luego
será desechada.

**¿Por qué esto ahorra trabajo en comparación con simplemente almacenar esos mensajes
en el hash de `session[]`?**

Al usar `flash[]` nuestro mensaje solo persiste durante el procesamiento de la
siguiente solicitud , a diferencia de `session[]` que lo mantiene disponible para todas las solicitudes, el primer comportamiento
se ajusta mejor a lo que queremos lograr.

***
### Ejecutando la aplicación en Sinatra
Ejecutamos el comando `bundle exec rackup port --4000` para iniciar
nuestra aplicación. 

![img_7.png](https://user-images.githubusercontent.com/59848543/273352991-f632b56f-1666-41a0-8746-c70e2f2fac8f.png)

![img_8.png](https://user-images.githubusercontent.com/59848543/273352992-e253c7a1-b80a-48d9-85be-ad447c0ec4c5.png)

**Según el resultado de ejecutar este comando, ¿Cuál es la URL completa que debes
visitar para visitar la página New Game?**

`http://127.0.0.1:4000/new`
Siendo `4000` el puerto que estamos usando.

***
**¿Dónde está el código HTML de esta página?**

En la carpeta `/views` en el archivo `new.erb`.

![img_9.png](https://user-images.githubusercontent.com/59848543/273352989-2e870d02-a1a1-445a-973a-e3a701084c74.png)

### Funcionamiento
Al ingresar a la **URL** previamente descrita nos encontramos
con la pantalla principal del juego la cual
se ejecuta debido al bloque de código siguiente:

```Ruby
get '/new' do
erb :new
end
```

La llamada `erb :new` nos lleva al archivo `new.erb` donde tenemos la estructura de la página
principal y la acción que produce el apretar el botón
**NEW GAME**.

```HTML
<form action="/create" method="post">
  <div class="form-row py-3 border-top">
    <input type="submit" value="New Game" class="col-md-2 offset-md-5 btn btn-primary form-control"/>
  </div>
</form>
```
La plantilla `new.erb` nos redirige a la ruta `/create` en donde
se inicializa el estado del juego con la variable
`@game`.

```Ruby
post '/create' do
  word = params[:word] || WordGuesserGame.get_random_word
  @game = WordGuesserGame.new(word)
  redirect '/show'
end
```
Esta ruta luego nos redirecciona a la ruta `/show`

```Ruby
get '/show' do
  if @game.check_win_or_lose == :win
    redirect '/win'
  elsif @game.check_win_or_lose == :lose
    redirect '/lose'
  else
    erb :show
  end
end
```
que finalmente llama a `erb :show`, la plantilla
del juego principal, en donde se renderiza nuestro aplicación
y podemos apreciar las adivinaciones
del jugador, los mensajes que creamos con `flash[]` en 
`<% if flash[:message]>` y las redirecciones a las rutas
`/win` y `/lose` cuando se acabe el juego.
```HTML
<% if flash[:message] %>
   <div class="alert alert-danger">
     <span class="error"><%= flash[:message] %></span>
   </div>
<% end %>

<div class="alert alert-warning">
  <p class="lead">
    Wrong Guesses:
    <span class="guesses"><%= @game.wrong_guesses %></span>
  </p>
</div>

<p class="alert alert-success">
  Word so far:
  <span class="word"><%= @game.word_with_guesses %></span>
</p>

<form action="/guess" method="post">
  <div class="form-group row">
    <label for="guess" class="col-md-2 col-form-label">Guess a letter:</label>
    <input type="text" name="guess" autocomplete="off"
           class="form-control col-md-1 mr-4"/>
    <input type="submit" value="Guess!" class="col-md-2 btn btn-success"/>
  </div>
</form>

<%= erb :new %>
```








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

Para evitar que el usuario haga trampas simplemente visitando GET/win vamos a verificar si el juego ha terminado o no. Entonces modificamos el archivo app.rb

```Ruby
  get '/show' do
    if @game.check_win_or_lose == :win
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      redirect '/lose'
    else
      erb :show
    end
  end
```
Modificamos los métodos GET/win y GET/lose para evitar trampas por parte del usuario
```Ruby
  get '/win' do
    if @game.check_win_or_lose == :win
      erb :win
    else
      flash[:message] = "No hagas trampa :3"
      redirect '/show'
    end
  end

  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      flash[:message] = "Por qué quieres perder? :c"
      redirect '/show'
    end
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

