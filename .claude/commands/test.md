---
description: Define e implementa la suite de tests del proyecto. Tests de meta tags, analytics, accesibilidad automática, E2E y redirects.
argument-hint: [tipo de test o feature a testear — ej: "formulario de contacto" o "suite completa"]
---

Estás en **fase de testing**. Tu rol: implementar tests que verifican que el sistema hace lo que los contratos especifican.

**$ARGUMENTS**

**Restricciones:**
- ✅ Escribe tests que verifican contratos definidos
- ✅ Tests son independientes entre sí
- ✅ Tests fallan por razones claras con mensajes descriptivos
- ❌ No modifica el código bajo test (reporta como hallazgo si hay que cambiar lógica)
- ❌ No escribe tests triviales que solo verifican que el código corre

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → stack, comandos de test
2. `docs/contracts/seo-metadata.md` → metadata que debe existir por página
3. `docs/contracts/structured-data.md` → JSON-LD requerido
4. `docs/analytics/measurement-plan.md` → eventos que deben disparar
5. `docs/discovery/01-existing-state.md` → mapa de redirects (si es proyecto existente)

---

## Tu flujo

### 1. Tests de SEO — meta tags por página

Verificar que cada página tiene la metadata correcta según docs/contracts/seo-metadata.md:

```typescript
// tests/seo/meta-tags.test.ts
import { describe, it, expect } from 'vitest';
import { render } from '@testing-library/react';

describe('SEO Meta Tags — Home', () => {
  it('tiene title tag en rango correcto (50-60 chars)', () => {
    const title = document.querySelector('title')?.textContent ?? '';
    expect(title.length).toBeGreaterThanOrEqual(50);
    expect(title.length).toBeLessThanOrEqual(60);
  });

  it('tiene meta description en rango correcto (150-160 chars)', () => {
    const desc = document.querySelector('meta[name="description"]')?.getAttribute('content') ?? '';
    expect(desc.length).toBeGreaterThanOrEqual(150);
    expect(desc.length).toBeLessThanOrEqual(160);
  });

  it('tiene canonical URL absoluta', () => {
    const canonical = document.querySelector('link[rel="canonical"]')?.getAttribute('href') ?? '';
    expect(canonical).toMatch(/^https?:\/\//);
  });

  it('tiene og:image con URL absoluta', () => {
    const ogImage = document.querySelector('meta[property="og:image"]')?.getAttribute('content') ?? '';
    expect(ogImage).toMatch(/^https?:\/\//);
  });

  it('tiene un solo H1', () => {
    const h1s = document.querySelectorAll('h1');
    expect(h1s.length).toBe(1);
  });
});
```

---

### 2. Tests de structured data

```typescript
// tests/seo/structured-data.test.ts
describe('Structured Data', () => {
  it('tiene JSON-LD de Organization en todas las páginas', () => {
    const scripts = document.querySelectorAll('script[type="application/ld+json"]');
    const schemas = Array.from(scripts).map(s => JSON.parse(s.textContent ?? '{}'));
    const org = schemas.find(s => s['@type'] === 'Organization');
    expect(org).toBeDefined();
    expect(org.name).toBeTruthy();
    expect(org.url).toMatch(/^https?:\/\//);
  });
  
  it('el JSON-LD es JSON válido', () => {
    const scripts = document.querySelectorAll('script[type="application/ld+json"]');
    scripts.forEach(script => {
      expect(() => JSON.parse(script.textContent ?? '')).not.toThrow();
    });
  });
});
```

---

### 3. Tests de analytics — eventos

Verificar que los eventos del measurement-plan.md disparan correctamente:

```typescript
// tests/analytics/events.test.ts
import { vi } from 'vitest';
import { trackEvent } from '@/lib/analytics';

describe('Analytics — eventos', () => {
  beforeEach(() => {
    // Mock de gtag
    window.gtag = vi.fn();
  });

  it('cta_click dispara con las propiedades correctas', () => {
    const btn = document.querySelector('[data-cta="hero-principal"]') as HTMLElement;
    btn.click();
    
    expect(window.gtag).toHaveBeenCalledWith('event', 'cta_click', 
      expect.objectContaining({
        cta_text: expect.any(String),
        cta_location: expect.any(String),
        page: expect.any(String)
      })
    );
  });

  it('cta_click NO incluye PII', () => {
    const btn = document.querySelector('[data-cta="hero-principal"]') as HTMLElement;
    btn.click();
    
    const callArgs = (window.gtag as ReturnType<typeof vi.fn>).mock.calls[0][2];
    expect(callArgs).not.toHaveProperty('email');
    expect(callArgs).not.toHaveProperty('phone');
    expect(callArgs).not.toHaveProperty('nombre');
  });

  it('form_submit_success dispara solo después de respuesta exitosa', async () => {
    // Mockear fetch exitoso
    global.fetch = vi.fn().mockResolvedValue({ ok: true, status: 200 });
    
    const form = document.querySelector('form') as HTMLFormElement;
    form.dispatchEvent(new Event('submit'));
    await vi.waitFor(() => {
      expect(window.gtag).toHaveBeenCalledWith('event', 'form_submit_success', expect.any(Object));
    });
  });
});
```

---

### 4. Tests de accesibilidad automática (axe-core)

```typescript
// tests/accessibility/axe.test.ts
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
// o: import { configureAxe } from 'axe-playwright' para E2E

expect.extend(toHaveNoViolations);

describe('Accesibilidad automática — axe-core', () => {
  it('home no tiene violaciones WCAG AA', async () => {
    const { container } = render(<HomePage />);
    const results = await axe(container, {
      runOnly: { type: 'tag', values: ['wcag2aa'] }
    });
    expect(results).toHaveNoViolations();
  });

  it('formulario de contacto no tiene violaciones', async () => {
    const { container } = render(<ContactPage />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

---

### 5. Tests E2E — flujo principal en mobile y desktop

```typescript
// tests/e2e/flujo-principal.spec.ts (Playwright)
import { test, expect, devices } from '@playwright/test';

test.describe('Flujo principal — Desktop (1280px)', () => {
  test.use({ viewport: { width: 1280, height: 720 } });

  test('usuario puede completar el flujo de conversión principal', async ({ page }) => {
    await page.goto('/');
    
    // Verificar que el H1 está visible
    await expect(page.locator('h1')).toBeVisible();
    
    // Click en CTA principal
    await page.click('[data-cta="hero-principal"]');
    
    // Verificar navegación o modal
    // ...
    
    // Completar formulario
    await page.fill('[name="nombre"]', 'Usuario de prueba');
    await page.fill('[name="email"]', 'test@ejemplo.com');
    await page.click('button[type="submit"]');
    
    // Verificar confirmación
    await expect(page.locator('[data-testid="confirmacion"]')).toBeVisible();
  });
});

test.describe('Flujo principal — Mobile (375px)', () => {
  test.use(devices['iPhone 12']);

  test('el flujo completo funciona en mobile con una mano', async ({ page }) => {
    await page.goto('/');
    
    // Verificar que el nav mobile funciona
    await page.click('[aria-label="Abrir menú"]');
    await expect(page.locator('nav')).toBeVisible();
    
    // Verificar que el CTA es alcanzable
    const cta = page.locator('[data-cta="hero-principal"]');
    await expect(cta).toBeInViewport();
    
    // Verificar tamaño del target táctil
    const box = await cta.boundingBox();
    expect(box?.height).toBeGreaterThanOrEqual(44);
    expect(box?.width).toBeGreaterThanOrEqual(44);
  });
});
```

---

### 6. Tests de redirects (solo proyectos existentes)

```typescript
// tests/redirects/mapa-redirects.test.ts
import { test, expect } from '@playwright/test';

const REDIRECT_MAP = [
  // De docs/discovery/01-existing-state.md
  { from: '/about-us', to: '/nosotros', status: 301 },
  { from: '/servicios-old', to: '/servicios', status: 301 },
];

REDIRECT_MAP.forEach(({ from, to, status }) => {
  test(`${from} redirige a ${to} con ${status}`, async ({ request }) => {
    const response = await request.get(from, { maxRedirects: 0 });
    expect(response.status()).toBe(status);
    expect(response.headers()['location']).toContain(to);
  });
});

// Verificar que no hay cadenas de redirects
test('no hay cadenas de redirects (A→B→C)', async ({ request }) => {
  for (const { from, to } of REDIRECT_MAP) {
    const response = await request.get(from, { maxRedirects: 1 });
    // Si llegó con maxRedirects=1, no hay cadena
    expect(response.ok()).toBe(true);
  }
});
```

---

## Sugerencia Git al terminar

```bash
git add tests/
git commit -m "test: suite completa — SEO, analytics, accesibilidad, E2E y redirects"
```
