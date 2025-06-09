import { Component, OnInit, OnDestroy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatCardModule } from '@angular/material/card';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { HealthCheckService, HealthStatus } from './health-check.service';
import { interval, Subscription } from 'rxjs';
import { startWith, switchMap } from 'rxjs/operators';

@Component({
  selector: 'mifosx-health-indicator',
  standalone: true,
  imports: [
    CommonModule,
    MatIconModule,
    MatButtonModule,
    MatTooltipModule,
    MatCardModule,
    MatProgressSpinnerModule
  ],
  template: `
    <div class="health-indicator" [ngClass]="'health-' + healthStatus?.status">
      <!-- Compact indicator for header -->
      <div *ngIf="compact" class="compact-indicator" [matTooltip]="getStatusTooltip()" (click)="toggleDetails()">
        <mat-icon [ngClass]="getStatusIconClass()">
          {{ getStatusIcon() }}
        </mat-icon>
        <span class="status-text">{{ getStatusText() }}</span>
      </div>

      <!-- Detailed view -->
      <mat-card *ngIf="!compact || showDetails" class="health-details">
        <mat-card-header>
          <mat-card-title class="status-title">
            <mat-icon [ngClass]="getStatusIconClass()">
              {{ getStatusIcon() }}
            </mat-icon>
            System Health Status
            <button mat-icon-button (click)="refreshHealth()" class="refresh-btn">
              <mat-icon [class.spinning]="isRefreshing">refresh</mat-icon>
            </button>
          </mat-card-title>
          <mat-card-subtitle> Last updated: {{ healthStatus?.timestamp | date: 'medium' }} </mat-card-subtitle>
        </mat-card-header>

        <mat-card-content>
          <!-- Overall status -->
          <div class="overall-status">
            <h3>
              Overall Status:
              <span [ngClass]="'status-' + healthStatus?.status">
                {{ healthStatus?.status?.toUpperCase() }}
              </span>
            </h3>
          </div>

          <!-- Services status -->
          <div class="services-status" *ngIf="healthStatus?.services">
            <h4>Services</h4>
            <div class="service-grid">
              <!-- Frontend -->
              <div class="service-item" [ngClass]="'status-' + healthStatus.services.frontend?.status">
                <mat-icon>web</mat-icon>
                <div class="service-info">
                  <span class="service-name">Frontend</span>
                  <span class="service-status">{{ healthStatus.services.frontend?.status?.toUpperCase() }}</span>
                  <span class="response-time" *ngIf="healthStatus.services.frontend?.responseTime">
                    {{ healthStatus.services.frontend.responseTime }}ms
                  </span>
                </div>
              </div>

              <!-- Backend (Fineract) -->
              <div class="service-item" [ngClass]="'status-' + healthStatus.services.backend?.status">
                <mat-icon>storage</mat-icon>
                <div class="service-info">
                  <span class="service-name">Fineract API</span>
                  <span class="service-status">{{ healthStatus.services.backend?.status?.toUpperCase() }}</span>
                  <span class="response-time" *ngIf="healthStatus.services.backend?.responseTime">
                    {{ healthStatus.services.backend.responseTime }}ms
                  </span>
                </div>
              </div>

              <!-- Database -->
              <div class="service-item" [ngClass]="'status-' + healthStatus.services.database?.status">
                <mat-icon>database</mat-icon>
                <div class="service-info">
                  <span class="service-name">Database</span>
                  <span class="service-status">{{ healthStatus.services.database?.status?.toUpperCase() }}</span>
                  <span class="response-time" *ngIf="healthStatus.services.database?.responseTime">
                    {{ healthStatus.services.database.responseTime }}ms
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- System metadata -->
          <div class="metadata" *ngIf="healthStatus?.metadata">
            <h4>System Information</h4>
            <div class="metadata-grid">
              <div class="metadata-item">
                <span class="label">Version:</span>
                <span class="value">{{ healthStatus.metadata.version }}</span>
              </div>
              <div class="metadata-item">
                <span class="label">Environment:</span>
                <span class="value">{{ healthStatus.metadata.environment }}</span>
              </div>
              <div class="metadata-item">
                <span class="label">Uptime:</span>
                <span class="value">{{ formatUptime(healthStatus.metadata.uptime) }}</span>
              </div>
            </div>
          </div>

          <!-- Error details -->
          <div class="error-details" *ngIf="hasErrors()">
            <h4>Error Details</h4>
            <div class="error-list">
              <div *ngFor="let error of getErrors()" class="error-item">
                <mat-icon>error</mat-icon>
                <span>{{ error }}</span>
              </div>
            </div>
          </div>
        </mat-card-content>
      </mat-card>

      <!-- Loading indicator -->
      <div *ngIf="isRefreshing && compact" class="loading-indicator">
        <mat-progress-spinner diameter="20" mode="indeterminate"></mat-progress-spinner>
      </div>
    </div>
  `,
  styles: [
    `
      .health-indicator {
        position: relative;
      }

      .compact-indicator {
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        padding: 4px 8px;
        border-radius: 4px;
        transition: background-color 0.2s;
      }

      .compact-indicator:hover {
        background-color: rgba(0, 0, 0, 0.05);
      }

      .status-text {
        font-size: 12px;
        font-weight: 500;
      }

      .health-details {
        min-width: 400px;
        max-width: 600px;
      }

      .status-title {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .refresh-btn {
        margin-left: auto;
      }

      .spinning {
        animation: spin 1s linear infinite;
      }

      @keyframes spin {
        from {
          transform: rotate(0deg);
        }
        to {
          transform: rotate(360deg);
        }
      }

      .overall-status h3 {
        margin: 0 0 16px 0;
      }

      .service-grid {
        display: grid;
        gap: 12px;
        margin-top: 8px;
      }

      .service-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
      }

      .service-info {
        display: flex;
        flex-direction: column;
        gap: 2px;
      }

      .service-name {
        font-weight: 500;
      }

      .service-status {
        font-size: 12px;
        font-weight: 600;
      }

      .response-time {
        font-size: 11px;
        color: #666;
      }

      .metadata-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 8px;
        margin-top: 8px;
      }

      .metadata-item {
        display: flex;
        justify-content: space-between;
      }

      .label {
        font-weight: 500;
        color: #666;
      }

      .error-list {
        margin-top: 8px;
      }

      .error-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 4px 0;
        color: #d32f2f;
      }

      /* Status-based styling */
      .health-healthy .compact-indicator mat-icon,
      .status-healthy {
        color: #4caf50;
      }

      .health-degraded .compact-indicator mat-icon,
      .status-degraded {
        color: #ff9800;
      }

      .health-unhealthy .compact-indicator mat-icon,
      .status-unhealthy {
        color: #f44336;
      }

      .status-up {
        color: #4caf50;
      }
      .status-down {
        color: #f44336;
      }
      .status-degraded {
        color: #ff9800;
      }

      .service-item.status-up {
        border-color: #4caf50;
        background-color: rgba(76, 175, 80, 0.05);
      }

      .service-item.status-down {
        border-color: #f44336;
        background-color: rgba(244, 67, 54, 0.05);
      }

      .service-item.status-degraded {
        border-color: #ff9800;
        background-color: rgba(255, 152, 0, 0.05);
      }

      .loading-indicator {
        position: absolute;
        top: 50%;
        right: -30px;
        transform: translateY(-50%);
      }
    `

  ]
})
export class HealthIndicatorComponent implements OnInit, OnDestroy {
  @Input() compact = true;
  @Input() autoRefresh = true;
  @Input() refreshInterval = 30000; // 30 seconds

  healthStatus: HealthStatus | null = null;
  showDetails = false;
  isRefreshing = false;
  private subscription?: Subscription;

  constructor(private healthService: HealthCheckService) {}

  ngOnInit(): void {
    this.startHealthMonitoring();
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }

  private startHealthMonitoring(): void {
    if (this.autoRefresh) {
      this.subscription = interval(this.refreshInterval)
        .pipe(
          startWith(0),
          switchMap(() => {
            this.isRefreshing = true;
            return this.healthService.getHealthStatus();
          })
        )
        .subscribe({
          next: (status) => {
            this.healthStatus = status;
            this.isRefreshing = false;
          },
          error: (error) => {
            console.error('Health monitoring error:', error);
            this.isRefreshing = false;
          }
        });
    } else {
      this.refreshHealth();
    }
  }

  refreshHealth(): void {
    this.isRefreshing = true;
    this.healthService.getHealthStatus().subscribe({
      next: (status) => {
        this.healthStatus = status;
        this.isRefreshing = false;
      },
      error: (error) => {
        console.error('Health check error:', error);
        this.isRefreshing = false;
      }
    });
  }

  toggleDetails(): void {
    this.showDetails = !this.showDetails;
  }

  getStatusIcon(): string {
    switch (this.healthStatus?.status) {
      case 'healthy':
        return 'check_circle';
      case 'degraded':
        return 'warning';
      case 'unhealthy':
        return 'error';
      default:
        return 'help';
    }
  }

  getStatusIconClass(): string {
    return `status-icon status-${this.healthStatus?.status || 'unknown'}`;
  }

  getStatusText(): string {
    return this.healthStatus?.status?.toUpperCase() || 'UNKNOWN';
  }

  getStatusTooltip(): string {
    if (!this.healthStatus) return 'Health status unknown';

    const services = this.healthStatus.services;
    const upServices = Object.values(services).filter((s) => s.status === 'up').length;
    const totalServices = Object.values(services).length;

    return `System Health: ${this.healthStatus.status.toUpperCase()}\n${upServices}/${totalServices} services operational\nClick for details`;
  }

  hasErrors(): boolean {
    if (!this.healthStatus?.services) return false;

    return Object.values(this.healthStatus.services).some((service) => service.status === 'down' || service.error);
  }

  getErrors(): string[] {
    if (!this.healthStatus?.services) return [];

    const errors: string[] = [];
    Object.entries(this.healthStatus.services).forEach(
      ([
        name,
        service
      ]) => {
        if (service.error) {
          errors.push(`${name}: ${service.error}`);
        }
      }
    );

    return errors;
  }

  formatUptime(ms: number): string {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (days > 0) return `${days}d ${hours % 24}h`;
    if (hours > 0) return `${hours}h ${minutes % 60}m`;
    if (minutes > 0) return `${minutes}m ${seconds % 60}s`;
    return `${seconds}s`;
  }
}
