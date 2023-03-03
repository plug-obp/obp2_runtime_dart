import 'dart:convert';
import 'dart:typed_data';

import 'package:obp2_runtime/obp2_runtime.dart';

abstract class ILanguageService<C, A, V, E, I, O> {
  late ILanguageModule<C, A, V, E, I, O> module;
  set setModule(ILanguageModule<C, A, V, E, I, O> module) {
    this.module = module;
  }
}

abstract class MaybeStutter<A> {}

class Stutter<A> extends MaybeStutter<A> {}

class Enabled<A> extends MaybeStutter<A> {
  A action;
  Enabled(this.action);
}

abstract class ILanguageModule<C, A, V, E, I, O> {
  ISemantics<C, A, V, E, I, O> semantics;
  V Function(E, I, C, MaybeStutter A, O, C) evaluate;
  ILanguageModule(this.semantics, this.evaluate) {
    semantics.module = this;
  }
}

abstract class ISemantics<C, A, V, E, I, O>
    extends ILanguageService<C, A, V, E, I, O> {
  Iterable<C> initialConfigurations();
  Iterable<A> enabledActions(I input, C source);
  Iterable<ExecutionOutcome<O, C>> execute(A action, I input, C source);
}

//a change which is a result or consequence of an action
class ExecutionOutcome<O, C> {
  C configuration;
  O output;
  ExecutionOutcome(this.configuration, this.output);
}

abstract class ILanguageCodec<C, A, V, E, I, O, T> {
  Codec<C, T> get configurationCodec;
  Codec<A, T> get actionCodec;
  Codec<V, T> get valueCodec;
  Codec<E, T> get expressionCodec;
  Codec<I, T> get inputCodec;
  Codec<O, T> get outputCodec;
}

abstract class LanguageToByteArrayCodec<C, A, V, E, I, O>
    extends ILanguageCodec<C, A, V, E, I, O, ByteBuffer> {}

///**S**emantic **L**anguage **I**nterface (__SLI__)
///An SLI captures the semantics of a language through the [STR] abstraction
///along with some helper functions, which allows the tools to
///interact with the semantics
class SemanticLanguageInterface<C, A, E, V> {
  SemanticTransitionRelation<C, A> semantics;
  V Function(E, C) evaluate;
  late Function(C) extractConfigurationToJson;
  late Function(C) extractActionToJson;

  SemanticLanguageInterface(
      {required this.semantics,
      required this.evaluate,
      extractConfigurationToJson,
      extractActionToJson}) {
    semantics.parent = this;

    this.extractConfigurationToJson =
        extractConfigurationToJson ?? defaultConfigurationToJson;
    this.extractActionToJson = extractActionToJson ?? defaultActionToJson;
  }

  defaultConfigurationToJson(configuration) => jsonDecode('''{
              "type": "error", 
              "message": "Cannot extract JSON", 
              "value": "Configuration[${tenOrLess(configuration.toString())}...]",
              "solution": "implement extractConfigurationToJson"
              }''');

  defaultActionToJson(action) => jsonDecode('''{
              "type": "error", 
              "message": "Cannot extract JSON", 
              "value": "Action[${tenOrLess(action.toString())}...]",
              "solution": "implement extractActionToJson"
              }''');

  tenOrLess(String name) {
    return name.length <= 10 ? name : name.substring(0, 10);
  }
}
