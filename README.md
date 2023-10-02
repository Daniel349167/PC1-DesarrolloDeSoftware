# PC1
***
## Integrantes
- Juan de Dios Fernando Lerzundi Ríos
- José Daniel Zapata Anco
- Omar Baldomero Vite Allca
- Daniel Ureta Espinal
***
## Introducción
## Objetivo
Comprender los pasos necesarios para crear, versionar e implementar una aplicación SaaS, incluido el seguimiento de las librerías de las que depende para que sus entornos de producción y desarrollo sean lo más similares posible.

## Creación y Versionado de una aplicación SaaS
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
## Parte 2: RESTful para Wordguesser
...
## Parte 3: Conexión de WordGuesserGame a Sinatra
...
## Parte 4: Cucumber
...
## Parte 5: Otros casos
...
