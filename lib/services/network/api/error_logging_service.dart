class ErrorLoggingApiService {
  // method to log error
  Future logErrorToServer(
      {required String fileName,
      String className = "",
      required String functionName,
      required String errorInfo,
      String remark = ""}) async {
    String errorMessage =
        "File : $fileName -> ${className != '' ? 'Class : $className - > ' : ""} Function : $functionName -> ErrorInfo : $errorInfo -> ${remark != '' ? 'Remark : $remark - > ' : ""}";

    print("@@@@lookie Error Logging service $errorMessage");
  }
}
