name 'apiv1'
summary 'Commands that target the V1 providers endpoint'

option :u, 'url', 'set the base url to connect to',
       argument: :required,
       default: 'http://localhost:3001'
option :t, 'token', 'set the authorization token',
       argument: :required,
       default: 'bats'
option :P, 'max-pages', 'maximum number of pages to request',
       default: 200,
       argument: :optional,
       transform: method(:Integer)
instance_eval(&MCB.remote_connect_options)
