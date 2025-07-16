import { Routes } from '@angular/router';
import { Landing } from './features/landing/landing';
import { AuthFormComponent } from './features/auth-form/auth-form';

export const routes: Routes = [
  {
    path: '',
    component: Landing,
    pathMatch: 'full'
  },
  {
    path: 'parcels',
    loadChildren: () => import('./features/parcels/parcels-module').then(m => m.ParcelsModule)
  },
  {
    path: 'dashboard',
    loadChildren: () => import('./features/dashboard/dashboard-module').then(m => m.DashboardModule)
  },
  {
    path: 'auth',
    component: AuthFormComponent
  },
  {
    path: '**',
    redirectTo: ''
  }
];
