# Testability Recommendations

This document outlines recommendations for improving the testability of components that are currently challenging to test in the `alfred_jetbrains_cli` project.

## Components Difficult to Test

### 1. `helper.dart` - `debugMode` and `alfredMode`

**Problem**: These are global `final` variables that depend on `Platform.environment` at initialization time.

```dart
final bool debugMode = _debugMode();
final bool alfredMode = _alfredMode();
```

**Recommendation**: Use dependency injection or a configuration class.

```dart
// Option 1: Injectable configuration class
class AppConfig {
  final bool debugMode;
  final bool alfredMode;
  
  AppConfig({bool? debugMode, bool? alfredMode})
      : debugMode = debugMode ?? _checkDebugMode(),
        alfredMode = alfredMode ?? _checkAlfredMode();
  
  static bool _checkDebugMode() {
    return Platform.environment.containsKey('alfred_debug');
  }
  
  static bool _checkAlfredMode() {
    return Platform.environment.containsKey('alfred_version');
  }
}

// Usage in tests:
final testConfig = AppConfig(debugMode: true, alfredMode: false);
```

---

### 2. `JetBrainsProductLocator` - File System Dependencies

**Problem**: Direct usage of `Platform.environment`, `Directory`, and `File` classes makes unit testing impossible without actual file system operations.

**Recommendation**: Inject abstractions for file system and environment access.

```dart
// Abstract interface for file system operations
abstract class FileSystemService {
  bool directoryExists(String path);
  List<FileSystemEntity> listDirectory(String path);
}

// Abstract interface for environment access
abstract class EnvironmentService {
  String? getEnv(String key);
}

// Real implementations for production
class RealFileSystemService implements FileSystemService {
  @override
  bool directoryExists(String path) => Directory(path).existsSync();
  
  @override
  List<FileSystemEntity> listDirectory(String path) => Directory(path).listSync();
}

// Mock implementations for testing
class MockFileSystemService implements FileSystemService {
  Map<String, List<String>> mockDirectories = {};
  
  @override
  bool directoryExists(String path) => mockDirectories.containsKey(path);
  
  @override
  List<FileSystemEntity> listDirectory(String path) => /* mock implementation */;
}

// Refactored class
class JetBrainsProductLocator {
  final JetBrainsProduct product;
  final FileSystemService fileSystem;
  final EnvironmentService environment;
  
  JetBrainsProductLocator(
    this.product, {
    FileSystemService? fileSystem,
    EnvironmentService? environment,
  })  : fileSystem = fileSystem ?? RealFileSystemService(),
        environment = environment ?? RealEnvironmentService();
}
```

---

### 3. `JetBrainsProjects` - Similar File System Dependencies

**Problem**: Same issues as `JetBrainsProductLocator` - tight coupling to file system and environment.

**Recommendation**: Apply the same dependency injection pattern as above.

---

### 4. `JetBrainsProjectsExtractor` - `_replaceHome` Private Method

**Problem**: The `_replaceHome` method uses `Platform.environment['HOME']` directly.

**Recommendation**: Accept home directory as parameter or make the method testable.

```dart
class JetBrainsProjectsExtractor {
  // Add optional home parameter for testing
  static Iterable<String> recentProjectsExtractor(
    File xmlFile, {
    String? homeDirectory,
  }) {
    final home = homeDirectory ?? Platform.environment['HOME']!;
    // ... use home instead of Platform.environment['HOME']
  }
}
```

---

### 5. `AlfredResponse` - Output and Global State

**Problem**: 
- Uses `print()` directly for output
- Depends on global `debugMode` and `loggerOutput`

**Recommendation**: Inject output writer and configuration.

```dart
abstract class OutputWriter {
  void write(String content);
}

class ConsoleOutputWriter implements OutputWriter {
  @override
  void write(String content) => print(content);
}

class AlfredResponse {
  final OutputWriter output;
  final bool debugMode;
  
  AlfredResponse({
    OutputWriter? output,
    bool? debugMode,
  })  : output = output ?? ConsoleOutputWriter(),
        debugMode = debugMode ?? helper.debugMode;
  
  void renderItems(List<ResultItem> items) {
    // ... use this.output.write() instead of print()
  }
}

// In tests:
class MockOutputWriter implements OutputWriter {
  final List<String> outputs = [];
  
  @override
  void write(String content) => outputs.add(content);
}

test('renderItems outputs correct JSON', () {
  final mockOutput = MockOutputWriter();
  final response = AlfredResponse(output: mockOutput, debugMode: false);
  response.renderItems([/* items */]);
  expect(mockOutput.outputs.first, contains('"items"'));
});
```

---

### 6. `JetBrainsProductConfiguration.config()` - Static Cached State

**Problem**: Uses static `_config` cache and reads from `Platform.environment`.

**Recommendation**: 
- Remove static caching or provide a way to reset it for tests
- Inject environment access

```dart
class JetBrainsProductConfiguration {
  // For testing: allow reset of cached config
  static void resetConfig() {
    _config = null;
  }
  
  // Or better: use instance methods instead of static
  final EnvironmentService environment;
  
  JetBrainsProductConfiguration({EnvironmentService? environment})
      : environment = environment ?? RealEnvironmentService();
}
```

---

### 7. Logger - Global State and File I/O

**Problem**: Logger is a global instance with file I/O dependencies.

**Recommendation**: Create a logger factory that can be mocked.

```dart
abstract class LoggerFactory {
  Logger createLogger();
}

class ProductionLoggerFactory implements LoggerFactory {
  @override
  Logger createLogger() => Logger(/* current configuration */);
}

class TestLoggerFactory implements LoggerFactory {
  @override
  Logger createLogger() => Logger(output: MemoryOutput());
}
```

---

### 8. Command Classes (SearchCommand, etc.)

**Problem**: Commands instantiate dependencies directly within `run()` method.

**Recommendation**: Use constructor injection for dependencies.

```dart
class SearchCommand extends Command<int> {
  final JetBrainsProductLocator Function(JetBrainsProduct) locatorFactory;
  final JetBrainsProjects Function(JetBrainsProduct) projectsFactory;
  
  SearchCommand({
    JetBrainsProductLocator Function(JetBrainsProduct)? locatorFactory,
    JetBrainsProjects Function(JetBrainsProduct)? projectsFactory,
  })  : locatorFactory = locatorFactory ?? ((p) => JetBrainsProductLocator(p)),
        projectsFactory = projectsFactory ?? ((p) => JetBrainsProjects(p));
  
  @override
  FutureOr<int>? run() async {
    // Use injected factories
    final jbProduct = locatorFactory(product);
    final jbProjects = projectsFactory(product);
    // ...
  }
}
```

---

## Summary of Patterns

1. **Dependency Injection**: Replace direct instantiation with constructor injection
2. **Abstract Interfaces**: Create abstractions for external dependencies (file system, environment, output)
3. **Configuration Objects**: Bundle related configuration into injectable objects
4. **Factory Functions**: Use factories for creating dependent objects
5. **Avoid Global State**: Replace global `final` variables with injectable configuration
6. **Mockable Time**: Consider injecting `DateTime.now()` for time-dependent code

## Priority Recommendations

| Component | Effort | Impact | Priority |
|-----------|--------|--------|----------|
| `JetBrainsProjectsExtractor` | Low | Medium | High |
| `AlfredResponse` | Medium | High | High |
| `JetBrainsProductLocator` | Medium | High | Medium |
| `JetBrainsProjects` | Medium | High | Medium |
| `helper.dart` globals | Low | Medium | Medium |
| Command classes | High | Medium | Low |
| Logger | High | Low | Low |

Start with high-priority, low-effort changes first for quick wins.
