import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { URL } from 'src/environments/environment';
import { ILambdaRequest } from '../models/ilambdarequest.model';

@Injectable({
  providedIn: 'root'
})
export class DynamodbService {

  constructor(private http: HttpClient) { }

  list() {
    let req: ILambdaRequest = {
      operation: 'scan'
    }
    return this.http.post(URL, req);
  }

  insert(req: ILambdaRequest) {
    return this.http.post(URL, req);
  }

  wipe(req: ILambdaRequest) {
    return this.http.post(URL, req);
  }
}
