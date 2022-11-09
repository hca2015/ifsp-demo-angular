import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest, HttpResponse } from '@angular/common/http';
import { catchError, finalize, map, Observable } from 'rxjs';

@Injectable()
export class HeaderInterceptor implements HttpInterceptor {
    constructor() { }

    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        const headers = req.headers
            .set('Content-Type', 'application/json');
        const authReq = req.clone({ headers });

        (document.getElementById('loader') as HTMLDivElement).style.display = 'block';

        return next.handle(authReq).pipe(
            finalize(() => {
                (document.getElementById('loader') as HTMLDivElement).style.display = 'none';
            })
        );
    }
}