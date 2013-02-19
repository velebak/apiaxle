{ ModelCommand } = require "../command"

class exports.Api extends ModelCommand
  @modelName = "apiFactory"

  exec: ( commands, keypairs, cb ) ->
    id = commands.shift()

    switch command = commands.shift()
      when "create" then @create id, commands, keypairs, cb
      when "show" then @show id, commands, keypairs, cb

      # nothing entered
      when null then @show id, commands, keypairs, cb
      when undefined then @show id, commands, keypairs, cb

  show: ( id, commands, keypairs, cb ) =>
    @_getIdAndObject id, ( err, dbApi ) =>
      return cb err if err

      @GET path: "/v1/api/#{ id }", ( err, res ) ->
        return cb err if err

        res.parseJson ( err, json ) ->
          return cb err if err
          return cb null, json

  create: ( id, commands, keypairs, cb ) =>
    options =
      path: "/v1/api/#{ id }"
      headers:
        "content-type": "application/json"
      data: JSON.stringify keypairs

    @POST options, ( err, res ) ->
      return cb err if err

      res.parseJson ( err, json ) ->
        return cb err if err
        return cb null, json
