import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of, forkJoin } from 'rxjs';
import { map, catchError, timeout } from 'rxjs/operators';

export interface HealthStatus {
  status: 'healthy' | 'unhealthy' | 'degraded';
  timestamp: string;
  services: {
    frontend: ServiceHealth;
    backend: ServiceHealth;
    database: ServiceHealth;
  };
  metadata: {
    version: string;
    environment: string;
    uptime: number;
  };
}

export interface ServiceHealth {
  status: 'up' | 'down' | 'degraded';
  responseTime?: number;
  error?: string;
  details?: any;
}

@Injectable({
  providedIn: 'root'
})
export class HealthCheckService {
  private startTime = Date.now();
  private readonly httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache'
    })
  };

  constructor(private http: HttpClient) {}

  /**
   * Comprehensive health check for all services
   */
  getHealthStatus(): Observable<HealthStatus> {
    const checks = forkJoin({
      frontend: this.checkFrontendHealth(),
      backend: this.checkBackendHealth(),
      database: this.checkDatabaseHealth()
    });

    return checks.pipe(
      map((services) => this.buildHealthStatus(services)),
      catchError((error) => {
        console.error('Health check failed:', error);
        return of(this.buildErrorHealthStatus(error));
      })
    );
  }

  /**
   * Check frontend health (basic connectivity)
   */
  private checkFrontendHealth(): Observable<ServiceHealth> {
    const startTime = Date.now();

    return this.http.get('/assets/env.js', { responseType: 'text', ...this.httpOptions }).pipe(
      timeout(5000),
      map(() => ({
        status: 'up' as const,
        responseTime: Date.now() - startTime,
        details: { message: 'Frontend assets loaded successfully' }
      })),
      catchError((error: HttpErrorResponse) =>
        of({
          status: 'down' as const,
          responseTime: Date.now() - startTime,
          error: error.message,
          details: { statusCode: error.status, message: error.statusText }
        })
      )
    );
  }

  /**
   * Check Fineract backend health
   */
  private checkBackendHealth(): Observable<ServiceHealth> {
    const startTime = Date.now();
    const fineractUrl = this.getFineractApiUrl();

    if (!fineractUrl) {
      return of({
        status: 'down' as const,
        error: 'Fineract API URL not configured',
        responseTime: 0
      });
    }

    // Check Fineract health endpoint
    const healthUrl = `${fineractUrl}/actuator/health`;

    return this.http.get(healthUrl, this.httpOptions).pipe(
      timeout(10000),
      map((response: any) => ({
        status: response?.status === 'UP' ? ('up' as const) : ('degraded' as const),
        responseTime: Date.now() - startTime,
        details: response
      })),
      catchError((error: HttpErrorResponse) => {
        // Fallback to basic API endpoint if health endpoint not available
        return this.checkBasicFineractConnection().pipe(
          map((basicCheck) => ({
            ...basicCheck,
            responseTime: Date.now() - startTime
          }))
        );
      })
    );
  }

  /**
   * Check database health via Fineract
   */
  private checkDatabaseHealth(): Observable<ServiceHealth> {
    const startTime = Date.now();
    const fineractUrl = this.getFineractApiUrl();

    if (!fineractUrl) {
      return of({
        status: 'down' as const,
        error: 'Cannot check database - Fineract URL not configured',
        responseTime: 0
      });
    }

    // Check database health via Fineract database endpoint
    const dbHealthUrl = `${fineractUrl}/actuator/health/db`;

    return this.http.get(dbHealthUrl, this.httpOptions).pipe(
      timeout(10000),
      map((response: any) => ({
        status: response?.status === 'UP' ? ('up' as const) : ('down' as const),
        responseTime: Date.now() - startTime,
        details: response
      })),
      catchError((error: HttpErrorResponse) =>
        of({
          status: 'down' as const,
          responseTime: Date.now() - startTime,
          error: error.message,
          details: {
            statusCode: error.status,
            message: 'Database health check unavailable - may not be exposed'
          }
        })
      )
    );
  }

  /**
   * Basic Fineract connection check
   */
  private checkBasicFineractConnection(): Observable<ServiceHealth> {
    const fineractUrl = this.getFineractApiUrl();
    const apiUrl = `${fineractUrl}/offices`;

    return this.http.get(apiUrl, this.httpOptions).pipe(
      timeout(10000),
      map(() => ({
        status: 'up' as const,
        details: { message: 'Basic Fineract API connection successful' }
      })),
      catchError((error: HttpErrorResponse) =>
        of({
          status: 'down' as const,
          error: `Fineract API connection failed: ${error.message}`,
          details: { statusCode: error.status, message: error.statusText }
        })
      )
    );
  }

  /**
   * Get Fineract API URL from environment
   */
  private getFineractApiUrl(): string {
    const env = (window as any)['env'] || {};
    const baseUrl = env['fineractApiUrl'] || env['FINERACT_API_URL'] || '';
    const provider = env['apiProvider'] || env['FINERACT_API_PROVIDER'] || '/fineract-provider/api';
    const version = env['apiVersion'] || env['FINERACT_API_VERSION'] || '/v1';

    if (!baseUrl) {
      console.warn('Fineract API URL not found in environment configuration');
      return '';
    }

    return `${baseUrl.replace(/\/$/, '')}${provider}${version}`;
  }

  /**
   * Build comprehensive health status
   */
  private buildHealthStatus(services: any): HealthStatus {
    const allServicesUp = Object.values(services).every((service: any) => service.status === 'up');
    const anyServiceDown = Object.values(services).some((service: any) => service.status === 'down');

    let overallStatus: 'healthy' | 'unhealthy' | 'degraded';
    if (allServicesUp) {
      overallStatus = 'healthy';
    } else if (anyServiceDown) {
      overallStatus = 'unhealthy';
    } else {
      overallStatus = 'degraded';
    }

    return {
      status: overallStatus,
      timestamp: new Date().toISOString(),
      services,
      metadata: {
        version: this.getAppVersion(),
        environment: this.getEnvironment(),
        uptime: Date.now() - this.startTime
      }
    };
  }

  /**
   * Build error health status
   */
  private buildErrorHealthStatus(error: any): HealthStatus {
    return {
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      services: {
        frontend: { status: 'down', error: 'Health check failed' },
        backend: { status: 'down', error: 'Health check failed' },
        database: { status: 'down', error: 'Health check failed' }
      },
      metadata: {
        version: this.getAppVersion(),
        environment: this.getEnvironment(),
        uptime: Date.now() - this.startTime
      }
    };
  }

  /**
   * Get application version
   */
  private getAppVersion(): string {
    return (window as any)['env']?.['version'] || '1.0.0';
  }

  /**
   * Get current environment
   */
  private getEnvironment(): string {
    const env = (window as any)['env'] || {};
    return env['environment'] || env['NODE_ENV'] || 'production';
  }

  /**
   * Quick health check for monitoring
   */
  isHealthy(): Observable<boolean> {
    return this.getHealthStatus().pipe(
      map((status) => status.status === 'healthy'),
      catchError(() => of(false))
    );
  }
}
