spawn = require('child_process').spawn
path  = require('path')

parseBoolean = (value) ->
  value == 'true'

parsePort = (value) ->
  parseInt(value) || null

program = require('commander')
program.version('1.0.0')

runNpm = (args, env_args = {}) ->
  runCmd('npm', [args..., '--silent'], env_args)

runCmd = (cmd, args, env_args = {}) ->
  env = Object.create(process.env)
  Object.assign(env, env_args)

  child = spawn(cmd, args, { env: env, stdio: 'inherit' })

  child.stdout?.on 'data', (data) ->
    process.stdout.write(data)

  child.stderr?.on 'data', (data) ->
    process.stderr.write(data.toString())

  child.on 'exit', (exitCode) ->
    process.exit(exitCode)

executeScript = (scriptName, args) ->
  runCmd(path.resolve(__dirname + "/../script/#{scriptName}"), args)

program
  .command('new <package_name> <path>')
  .description('Create a new Maji app')
  .on '--help', ->
    console.log '  Example:\n  maji new org.example.my-app ~/Code/my-app'
  .action (packageName, path) ->
    if ! packageName.match /.*\..*\..*/
      console.log 'Please specify a valid package name, for example org.example.my-app'
      process.exit(1)
    executeScript('create-project', [packageName, path])

program
  .command('run <platform>')
  .description('Build and run a native app for the specified platform')
  .option('-e, --emulator', 'run on emulator instead of an actual device')
  .action (platform, options) ->
    deviceTypeArg = if options.emulator then '--emulator' else '--device'
    executeScript('run-on-device', [platform, deviceTypeArg, program.args...])

program
  .command('build [platform]')
  .description('Build a native app for the specified platform')
  .option('--release', 'create a release build')
  .action (platform, options) ->
    if platform
      releaseArg = if options.release then '--release' else '--debug'
      executeScript('build-app', [platform, releaseArg, program.args...])
    else
      runNpm(['run', 'build'])

program
  .command('test')
  .option('--watch', 'Run tests when project files change')
  .option('--unit', 'Run unit tests')
  .option('--integration', 'Run integration tests')
  .description('Run your project tests')
  .action (options) ->
    if options.watch
      return runNpm(['run', 'test:watch'])

    if options.unit
      return runNpm(['run', 'test:unit'])

    if options.features
      return runNpm(['run', 'test:integration'])

    runNpm(['test'])

program
  .command('start')
  .description('Run the maji dev server and compile changes on the fly')
  .option('-p --port [port]', 'Port to listen on [9090]', parsePort, 9090)
  .option('-l --livereload [flag]', 'Enable livereload [true]', parseBoolean, false)
  .action (options) ->
    env = {
      'SERVER_PORT': options.port,
      'LIVERELOAD': options.livereload
    }

    runCmd('npm', ['start'], env)

program.on '--help', ->
  process.exit(1)

program.on '*', (action) ->
  console.log "Unknown command '#{action}'"
  program.help()

program.parse(process.argv)
program.help() unless process.argv.slice(2).length
