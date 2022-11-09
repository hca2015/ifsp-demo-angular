import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BonusComponent } from './bonus/bonus.component';
import { HomeComponent } from './home/home.component';


const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'bonus', component: BonusComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }