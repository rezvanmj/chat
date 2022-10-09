// for indicating api response from bloc and listeting to it from view
// to navigate or show dialogs,snackbars and etc...
// it will be null when the bloc first startrs to indicate we havent
// had any api call yet, and will be occupied with either exception catched
// in cathc bloc or success class down below
class ApiResponse {
  final dynamic response;
  ApiResponse({this.response});
}

// some dumb class for returning inside api response to indicate everythinhg
// went as planned
class Success {
  final dynamic response;
  Success({this.response});
}
// return failure with message to show error dialog or ...
class Failure {
  final dynamic failuer;


  Failure(this.failuer);
}

String failureSentence({required String whatFailed}){
  return '$whatFailed Failed';
}