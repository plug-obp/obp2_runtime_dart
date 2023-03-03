import 'dart:convert';

///**S**emantic **L**anguage **I**nterface (__SLI__)
///An SLI captures the semantics of a language through the [STR] abstraction
///along with some helper functions, which allows the tools to
///interact with the semantics
class SLI<C, A, E, V> {
  STR<C, A> semantics;
  V Function(E, C) evaluate;
  late Function(C) extractConfigurationToJson;
  late Function(C) extractActionToJson;

  SLI(
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

///The **S**emantic **T**ransition **R**elation (__STR__) captures the subject
///language semantics through a transition relation metaphor that explicitly
/// exposes the semantic actions.
///
/// * [C] The subject language configuration type
/// * [A] The subject language action type
abstract class STR<C, A> {
  STR();
  late SLI parent;

  /// The initial configurations for the model associated with this
  /// language runtime. Typically there is only one initial configuration.
  /// But generally there can be more.
  ///
  /// For instance TLA+ defines the initial configuration as a set,
  /// the set of configurations allowed by the INIT predicate.
  Iterable<C> initial();

  /// Defines the set of actions enabled in the source configuration
  Iterable<A> actions(C source);

  /// Defines the set of target configurations
  /// obtained by executing the action in the source configuration
  Iterable<C> execute(A action, C source);
}

typedef Injector = SLI Function(dynamic);
typedef StringInjector = SLI Function(String);
