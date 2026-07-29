import { FormEvent, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'

import { supabase } from '@/lib/supabase'

const REMEMBER_EMAIL_KEY = 'auth.rememberedEmail'

export function LoginPage() {
  const navigate = useNavigate()
  const [email, setEmail] = useState(() => localStorage.getItem(REMEMBER_EMAIL_KEY) ?? '')
  const [password, setPassword] = useState('')
  const [rememberEmail, setRememberEmail] = useState(Boolean(localStorage.getItem(REMEMBER_EMAIL_KEY)))
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError(null)
    setLoading(true)

    const normalizedEmail = email.trim().toLowerCase()
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: normalizedEmail,
      password,
    })

    if (signInError) {
      setError('No se ha podido iniciar sesión. Revisa el correo y la contraseña.')
      setLoading(false)
      return
    }

    if (rememberEmail) {
      localStorage.setItem(REMEMBER_EMAIL_KEY, normalizedEmail)
    } else {
      localStorage.removeItem(REMEMBER_EMAIL_KEY)
    }

    navigate('/', { replace: true })
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4">
      <section className="w-full max-w-md rounded-xl border bg-background p-6 shadow-sm">
        <header className="mb-6 space-y-1">
          <h1 className="text-2xl font-semibold">Iniciar sesión</h1>
          <p className="text-sm text-muted-foreground">Accede con tu correo y contraseña.</p>
        </header>

        <form className="space-y-4" onSubmit={handleSubmit}>
          <label className="block space-y-1">
            <span className="text-sm font-medium">Correo electrónico</span>
            <input
              autoComplete="username"
              className="w-full rounded-md border px-3 py-2"
              name="email"
              onChange={(event) => setEmail(event.target.value)}
              required
              type="email"
              value={email}
            />
          </label>

          <label className="block space-y-1">
            <span className="text-sm font-medium">Contraseña</span>
            <input
              autoComplete="current-password"
              className="w-full rounded-md border px-3 py-2"
              minLength={8}
              name="password"
              onChange={(event) => setPassword(event.target.value)}
              required
              type="password"
              value={password}
            />
          </label>

          <div className="flex items-center justify-between gap-4 text-sm">
            <label className="flex items-center gap-2">
              <input
                checked={rememberEmail}
                onChange={(event) => setRememberEmail(event.target.checked)}
                type="checkbox"
              />
              Recordar correo
            </label>
            <Link className="underline underline-offset-4" to="/forgot-password">
              ¿Has olvidado la contraseña?
            </Link>
          </div>

          {error ? <p role="alert" className="text-sm text-destructive">{error}</p> : null}

          <button className="w-full rounded-md bg-primary px-4 py-2 text-primary-foreground" disabled={loading} type="submit">
            {loading ? 'Accediendo…' : 'Entrar'}
          </button>
        </form>
      </section>
    </main>
  )
}
