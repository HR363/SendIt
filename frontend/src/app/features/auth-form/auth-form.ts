import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NgIf, NgClass } from '@angular/common';

@Component({
  selector: 'app-auth-form',
  standalone: true,
  imports: [NgIf, NgClass],
  templateUrl: './auth-form.html',
  styleUrls: ['./auth-form.css']
})
export class AuthFormComponent implements OnInit {
  rightPanelActive = false;
  mode: 'signin' | 'signup' | 'verify' = 'signin';
  verificationEmail = '';

  constructor(private route: ActivatedRoute, private router: Router) {}

  ngOnInit(): void {
    this.route.queryParamMap.subscribe(params => {
      const mode = params.get('mode');
      this.rightPanelActive = mode === 'signup';
      if (this.mode !== 'verify') {
        this.mode = mode === 'signup' ? 'signup' : 'signin';
      }
    });
  }

  setPanel(signUp: boolean): void {
    this.rightPanelActive = signUp;
    this.mode = signUp ? 'signup' : 'signin';
    this.router.navigate([], {
      relativeTo: this.route,
      queryParams: { mode: signUp ? 'signup' : 'signin' },
      queryParamsHandling: 'merge',
      replaceUrl: true
    });
  }

  onSignup(email: string): void {
    // Simulate sending code to email
    this.verificationEmail = email;
    this.mode = 'verify';
  }

  onVerify(): void {
    // Simulate successful verification
    this.setPanel(false); // Go to login
    this.mode = 'signin';
  }
}
