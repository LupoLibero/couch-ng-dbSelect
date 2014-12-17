angular.module('selheure').
factory('DbSelect', ($location)->
  return {
    _baseName: ''

    getMainDb: () ->
      if $location.absUrl().indexOf('_rewrite')
        # ex: http://localhost:5984/selheure-demo/_design/selheure/_rewrite
        # -> selheure-demo
        name = $location.absUrl().split('/')[3]
      else
        # vhost case
        # ex: dev.selheure.org -> db: /selheure-dev
        name = 'selheure-' + $location.host().split('.')[0]
      console.log name[-5..], name[..-6]
      if name[-5..] == '_main'
        @_baseName = name[..-6]
      else
        @_baseName = name
      return {
        name: name
        url: '/' + name
      }

    getDb: (dbName) ->
      if @_baseName is ''
        @getMainDb()
      return {
        name: @_baseName + '_' + dbName
        url:  @_baseName + '_' + dbName
      }

    setDbConfig: (db, dbs) ->
      db.main = @getMainDb()
      splitted = db.main.name.split('-')
      db.main.instance = splitted.pop()
      applicationName = splitted.join('-')
      db.main.appName = applicationName + "-main"

      for dbName in dbs
        db[dbName] = @getDb(dbName)
        db[dbName].appName = applicationName + '-' + dbName

      return db
  }
)
