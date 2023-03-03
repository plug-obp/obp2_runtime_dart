import 'sli.dart';

class EmptySTR extends STR {
  @override
  Iterable initial() {
    return [null];
  }

  @override
  Iterable actions(source) {
    return [];
  }

  @override
  Iterable execute(action, source) {
    return [];
  }
}

injectEmptySLI(specification) {
  return SLI(semantics: EmptySTR(), evaluate: (e, c) => false);
}
