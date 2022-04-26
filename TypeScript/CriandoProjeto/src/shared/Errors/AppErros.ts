class AppError {
  public readonly message: string;
  public readonly statusCode: number;

  constructor(_message: string, _statusCode = 400) {
    this.message = _message;
    this.statusCode = _statusCode;
  }
}

export default AppError;
