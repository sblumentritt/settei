# Plugins

- Build Systems
  - CMakeProjectManager
  - GenericProjectManager
  - QmakeProjectManager
  - QtSupport
- C++
  - Beautifier (ClangFormat plugin is broken with system QtCreator)
  - ClangCodeModel
  - ClassView
  - CppEditor
  - CppTools
- Code Analyzer
- Core
  - Help
  - ProjectExplorer
  - TextEditor
  - Welcome
- Modeling
- Qt Creator
- Qt Quick
- Utilities
  - DiffEditor
  - ImageViewer
  - TaskList
  - TODO
- Version Control
  - Git
  - VcsBase

# Kits

- Create a Kit with Clang compiler and one with GCC compiler
- Use the LLDB debugger
- Change CMake generator to Unix Makefiles
- Kit name: `%{Compiler:Name}`

# Environment

- Auto-save interval: 10min

# C++

## File Naming

- Header Suffix: `hpp`
- Include guards: Use `#pragma once`

## Code Model

- Create a new configuration with the following content:
```
-pedantic -pedantic-errors -Wextra -Wall -Wdouble-promotion -Wundef -Wshadow
-Wnull-dereference -Wzero-as-null-pointer-constant -Wunused -Wold-style-cast
-Wsign-compare -Wunreachable-code -Wunreachable-code-break
-Wunreachable-code-return -Wextra-semi-stmt -Wreorder -Wcast-qual -Wconversion
-Wfour-char-constants -Wformat=2 -Wheader-hygiene -Wnewline-eof
-Wnon-virtual-dtor -Wpointer-arith -Wfloat-equal -Wpragmas
-Wreserved-user-defined-literal -Wsuper-class-method-mismatch -Wswitch-enum
-Wcovered-switch-default -Wthread-safety -Wunused-exception-parameter
-Wvector-conversion -Wkeyword-macro -Wformat-pedantic -Woverlength-strings
-Wdocumentation -Wimplicit-fallthrough -Wchar-subscripts
-Wmisleading-indentation -Wmissing-braces -Wpessimizing-move -Wdeprecated-copy
-Wredundant-move -Wtype-limits
```

# Beautifier

- Enable auto format on file save
- Tool: ClangFormat
- Restrict to files in current project
- Set predefined style for clang-format to **File**

# Build & Run

- Default build directory: `./build/%{BuildConfig:Name}`

# Debugger

- Use alternating row colors in debug views
- Switch to previous mode on exit
- Load system GDB pretty printers
- Use Intel style disassembly

# Analyzer

## Clang Tools

- Create a new configuration with the following clang-tidy content:
```
-*,bugprone-*,clang-analyzer-core.*,clang-analyzer-cplusplus.NewDeleteLeaks,clang-analyzer-deadcode.DeadStores,clang-analyzer-nullability.*,clang-analyzer-optin.cplusplus.VirtualCall,clang-analyzer-security.FloatLoopCounter,clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling,clang-analyzer-security.insecureAPI.UncheckedReturn,clang-analyzer-unix.API,clang-analyzer-unix.MismatchedDeallocator,cppcoreguidelines-avoid-goto,cppcoreguidelines-init-variables,cppcoreguidelines-macro-usage,cppcoreguidelines-narrowing-conversions,cppcoreguidelines-no-malloc,cppcoreguidelines-pro-type-const-cast,cppcoreguidelines-pro-type-cstyle-cast,cppcoreguidelines-pro-type-member-init,cppcoreguidelines-pro-type-static-cast-downcast,cppcoreguidelines-special-member-functions,hicpp-exception-baseclass,llvm-namespace-comment,misc-*,modernize-avoid-*,modernize-concat-nested-namespaces,modernize-deprecated-*,modernize-loop-convert,modernize-make-*,modernize-pass-by-value,modernize-raw-string-literal,modernize-redundant-void-arg,modernize-replace-*,modernize-return-braced-init-list,modernize-shrink-to-fit,modernize-unary-static-assert,modernize-use-auto,modernize-use-bool-literals,modernize-use-default-member-init,modernize-use-emplace,modernize-use-equals-*,modernize-use-nodiscard,modernize-use-noexcept,modernize-use-nullptr,modernize-use-override,modernize-use-transparent-functors,modernize-use-uncaught-exceptions,modernize-use-using,performance-*,readability-avoid-const-params-in-decls,readability-const-return-type,readability-container-size-empty,readability-delete-null-pointer,readability-deleted-default,readability-else-after-return,readability-function-size,readability-implicit-bool-conversion,readability-inconsistent-declaration-parameter-name,readability-isolate-declaration,readability-make-member-function-const,readability-misleading-indentation,readability-misplaced-array-index,readability-named-parameter,readability-non-const-parameter,readability-qualified-auto,readability-redundant-*,readability-simplify-*,readability-static-*,readability-string-compare,readability-uniqueptr-delete-release,readability-uppercase-literal-suffix,readability-use-anyofallof
```

## Cppcheck

- Custom arguments:
```
--enable=warning,performance,portability,style,information --suppress=syntaxError
--suppress=passedByValue --suppress=missingInclude --suppress=unusedStructMember
--suppress=unmatchedSuppression --suppress=missingIncludeSystem
--suppress=ConfigurationNotChecked
```
