import { Component, OnInit } from '@angular/core';
import { DynamodbService as DynamoDBService } from '../service/dynamodb.service';
import { MatTableDataSource } from '@angular/material/table';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ILambdaRequest } from '../models/ilambdarequest.model';

@Component({
  selector: 'app-bonus',
  templateUrl: './bonus.component.html',
  styleUrls: ['./bonus.component.scss']
})
export class BonusComponent implements OnInit {

  constructor(private dynamoDbService: DynamoDBService, private fb: FormBuilder) {
    this.form = fb.group({
      'nome': ['', Validators.required],
      'hobby': ['', Validators.required]
    });
  }

  dataSource = new MatTableDataSource<any>()
  form: FormGroup;
  displayedColumns = ['id', 'nome', 'hobby', 'acao'];

  ngOnInit(): void {
    this.list();
  }

  insert() {
    let req: ILambdaRequest = {
      operation: 'create',
      data: this.form.value
    };

    this.dynamoDbService.insert(req).subscribe({
      next: (res) => {
        this.form.reset();
        this.list();
      }
    })
  }

  wipe() {
    let req: ILambdaRequest = {
      operation: 'wipe',      
    };

    this.dynamoDbService.wipe(req).subscribe({
      next: (res) => {
        this.list();
      }
    })
  }

  list() {
    this.dynamoDbService.list().subscribe({
      next: (res) => {
        let sortedData = (res as []).sort(function(a: any, b: any) {
          var keyA = a.UserId,
            keyB = b.UserId;
          // Compare the 2 dates
          if (keyA > keyB) return -1;
          if (keyA < keyB) return 1;
          return 0;
        });

        this.dataSource.data = sortedData as [];
      },
      error: (res) => {
        console.log(res);
      }
    });
  }

  voltar() {
    history.back();
  }

}
