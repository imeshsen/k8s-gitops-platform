import React, { useState, useEffect } from 'react';
import { Sparkles, Calculator, Activity, Terminal, Send, RefreshCw, Layers } from 'lucide-react';

interface LogEntry {
  id: string;
  timestamp: string;
  method: string;
  endpoint: string;
  status: number;
  latency: number;
  response: string;
}

export default function App() {
  // Greeting State
  const [name, setName] = useState('');
  const [greeting, setGreeting] = useState('');
  const [greetingLoading, setGreetingLoading] = useState(false);

  // Calculator State
  const [valA, setValA] = useState('5');
  const [valB, setValB] = useState('7');
  const [calcResult, setCalcResult] = useState<{ a: number; b: number; sum: number } | null>(null);
  const [calcLoading, setCalcLoading] = useState(false);

  // Status & Logs State
  const [backendStatus, setBackendStatus] = useState<'checking' | 'online' | 'offline'>('checking');
  const [latency, setLatency] = useState<number | null>(null);
  const [logs, setLogs] = useState<LogEntry[]>([]);

  // Add a log helper
  const addLog = (method: string, endpoint: string, status: number, latency: number, response: any) => {
    const newLog: LogEntry = {
      id: Math.random().toString(36).substring(2, 9),
      timestamp: new Date().toLocaleTimeString(),
      method,
      endpoint,
      status,
      latency,
      response: JSON.stringify(response, null, 2),
    };
    setLogs((prev) => [newLog, ...prev].slice(0, 10)); // Keep last 10 logs
  };

  // Health check on mount
  const checkHealth = async () => {
    setBackendStatus('checking');
    const start = performance.now();
    try {
      // Fetch /api/hello with default parameter to check if server is up
      const res = await fetch(`${import.meta.env.VITE_API_URL || ''}/api/hello`);
      const duration = Math.round(performance.now() - start);
      if (res.ok) {
        setBackendStatus('online');
        setLatency(duration);
      } else {
        setBackendStatus('offline');
        setLatency(null);
      }
    } catch (err) {
      setBackendStatus('offline');
      setLatency(null);
    }
  };

  useEffect(() => {
    checkHealth();
  }, []);

  // Call Greeting API
  const handleGreetingSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (greetingLoading) return;
    setGreetingLoading(true);
    const targetName = name.trim() || 'World';
    const start = performance.now();
    const endpoint = `${import.meta.env.VITE_API_URL || ''}/api/hello?name=${encodeURIComponent(targetName)}`;
    
    try {
      const response = await fetch(endpoint);
      const duration = Math.round(performance.now() - start);
      const data = await response.json();
      
      if (response.ok) {
        setGreeting(data.message);
        addLog('GET', endpoint, response.status, duration, data);
        setBackendStatus('online');
      } else {
        setGreeting('Error: Could not retrieve greeting.');
        addLog('GET', endpoint, response.status, duration, data);
      }
    } catch (err) {
      setGreeting('Error: Backend service unreachable.');
      addLog('GET', endpoint, 0, Math.round(performance.now() - start), { error: 'Network Error' });
      setBackendStatus('offline');
    } finally {
      setGreetingLoading(false);
    }
  };

  // Call Calculator API
  const handleCalcSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (calcLoading) return;
    
    const a = parseInt(valA, 10);
    const b = parseInt(valB, 10);
    
    if (isNaN(a) || isNaN(b)) {
      // TODO(security): Render localized error state safely instead of using blocking window alerts
      return;
    }
    
    setCalcLoading(true);
    const start = performance.now();
    const endpoint = `${import.meta.env.VITE_API_URL || ''}/api/add?a=${a}&b=${b}`;
    
    try {
      const response = await fetch(endpoint);
      const duration = Math.round(performance.now() - start);
      const data = await response.json();
      
      if (response.ok) {
        setCalcResult({ a: data.a, b: data.b, sum: data.sum });
        addLog('GET', endpoint, response.status, duration, data);
        setBackendStatus('online');
      } else {
        addLog('GET', endpoint, response.status, duration, data);
      }
    } catch (err) {
      addLog('GET', endpoint, 0, Math.round(performance.now() - start), { error: 'Network Error' });
      setBackendStatus('offline');
    } finally {
      setCalcLoading(false);
    }
  };

  return (
    <div className="app-container">
      {/* Background patterns */}
      <div className="glow-sphere sphere-1"></div>
      <div className="glow-sphere sphere-2"></div>

      <header className="main-header">
        <div className="header-brand">
          <div className="brand-logo">
            <Layers className="logo-icon" />
          </div>
          <div>
            <h1>SpringReact</h1>
            <p className="subtitle">Micro-service Control Center</p>
          </div>
        </div>

        <div className="connection-status">
          <button onClick={checkHealth} className="refresh-btn" title="Refresh connection status">
            <RefreshCw className={`refresh-icon ${backendStatus === 'checking' ? 'spinning' : ''}`} />
          </button>
          
          <div className={`status-badge ${backendStatus}`}>
            <span className="pulse-dot"></span>
            <span className="status-text">
              {backendStatus === 'online' && `Connected (${latency}ms)`}
              {backendStatus === 'offline' && 'Offline'}
              {backendStatus === 'checking' && 'Checking...'}
            </span>
          </div>
        </div>
      </header>

      <main className="dashboard-grid">
        {/* Greeting Widget */}
        <section className="card widget-card">
          <div className="card-header">
            <div className="card-icon-container bg-pink">
              <Sparkles className="card-icon text-pink" />
            </div>
            <div>
              <h2>Greeting Portal</h2>
              <p className="card-description">Queries the Spring Boot greeting controller endpoint.</p>
            </div>
          </div>

          <form onSubmit={handleGreetingSubmit} className="widget-form">
            <div className="input-group">
              <label htmlFor="name-input">Target Name</label>
              <input
                id="name-input"
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Enter name (defaults to 'World')"
                className="form-input"
              />
            </div>
            <button type="submit" disabled={greetingLoading} className="submit-btn bg-pink-btn">
              {greetingLoading ? (
                <span className="loading-dots">Sending...</span>
              ) : (
                <>
                  <span>Greet Server</span>
                  <Send size={16} />
                </>
              )}
            </button>
          </form>

          {greeting && (
            <div className="response-box animated fadeIn">
              <div className="response-title">Server Response</div>
              <p className="response-text">{greeting}</p>
            </div>
          )}
        </section>

        {/* Calculator Widget */}
        <section className="card widget-card">
          <div className="card-header">
            <div className="card-icon-container bg-blue">
              <Calculator className="card-icon text-blue" />
            </div>
            <div>
              <h2>Backend Adder</h2>
              <p className="card-description">Calculates sums securely using server-side integer arithmetic.</p>
            </div>
          </div>

          <form onSubmit={handleCalcSubmit} className="widget-form">
            <div className="calc-inputs-row">
              <div className="input-group flex-1">
                <label htmlFor="input-a">Integer A</label>
                <input
                  id="input-a"
                  type="number"
                  value={valA}
                  onChange={(e) => setValA(e.target.value)}
                  className="form-input"
                  required
                />
              </div>
              <div className="calc-plus">+</div>
              <div className="input-group flex-1">
                <label htmlFor="input-b">Integer B</label>
                <input
                  id="input-b"
                  type="number"
                  value={valB}
                  onChange={(e) => setValB(e.target.value)}
                  className="form-input"
                  required
                />
              </div>
            </div>
            <button type="submit" disabled={calcLoading} className="submit-btn bg-blue-btn">
              {calcLoading ? (
                <span className="loading-dots">Calculating...</span>
              ) : (
                <>
                  <span>Sum on Backend</span>
                  <Calculator size={16} />
                </>
              )}
            </button>
          </form>

          {calcResult && (
            <div className="response-box animated fadeIn">
              <div className="response-title">Calculation Result</div>
              <div className="calc-result-display">
                <span className="calc-num">{calcResult.a}</span>
                <span className="calc-op">+</span>
                <span className="calc-num">{calcResult.b}</span>
                <span className="calc-op">=</span>
                <span className="calc-result-badge">{calcResult.sum}</span>
              </div>
            </div>
          )}
        </section>

        {/* Live Network Logs */}
        <section className="card full-width console-card">
          <div className="card-header">
            <div className="card-icon-container bg-green">
              <Terminal className="card-icon text-green" />
            </div>
            <div>
              <h2>API Network Logs</h2>
              <p className="card-description">Live stream of outgoing requests and responses mapped to the Spring Boot REST API.</p>
            </div>
          </div>

          <div className="console-container">
            <div className="console-header">
              <div className="console-dot dot-red"></div>
              <div className="console-dot dot-yellow"></div>
              <div className="console-dot dot-green"></div>
              <div className="console-title">developer-console @ localhost:5173</div>
            </div>
            <div className="console-body">
              {logs.length === 0 ? (
                <div className="console-empty">
                  <Activity size={24} className="console-pulse-icon" />
                  <p>Awaiting user interactions to populate endpoint logs...</p>
                </div>
              ) : (
                logs.map((log) => (
                  <div key={log.id} className="console-log-row">
                    <div className="console-log-summary">
                      <span className="log-time">[{log.timestamp}]</span>
                      <span className="log-method">{log.method}</span>
                      <span className="log-endpoint">{log.endpoint}</span>
                      <span className={`log-status ${log.status === 200 ? 'status-ok' : 'status-err'}`}>
                        {log.status === 0 ? 'FAIL' : log.status}
                      </span>
                      <span className="log-latency">{log.latency}ms</span>
                    </div>
                    <pre className="log-details">{log.response}</pre>
                  </div>
                ))
              )}
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
