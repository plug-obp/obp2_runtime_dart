import 'semantic_language_interface.dart';

///The **S**emantic **T**ransition **R**elation (__STR__) captures the subject
///language semantics through a transition relation metaphor that explicitly
/// exposes the semantic actions.
///
/// * [C] The subject language configuration type
/// * [A] The subject language action type
abstract class SemanticTransitionRelation<C, A> {
  SemanticTransitionRelation();
  late SemanticLanguageInterface parent;

  /// The initial configurations for the model associated with this
  /// language runtime. Typically there is only one initial configuration.
  /// But generally there can be more.
  ///
  /// For instance TLA+ defines the initial configuration as a set,
  /// the set of configurations allowed by the INIT predicate.
  Iterable<C> initialConfigurations();

  /// Defines the set of actions enabled in the source configuration
  Iterable<A> enabledActions(C source);

  /// Defines the set of target configurations
  /// obtained by executing the action in the source configuration
  Iterable<C> execute(A action, C source);
}
