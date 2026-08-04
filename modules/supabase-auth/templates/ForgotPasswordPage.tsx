import { FormEvent, useState } from 'react'

import { supabase } from '@/lib/supabase'

export function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [message, setMessage] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setLoading(true)
    setMessage(null)

    const redirectTo = `${window.location.origin}/reset-password`
    await supabase.auth.resetPasswordForEmail(email.trim().toLowerCase(), { redirectTo })

    // Use the same response whether or not the account exists.
    setMessage('Si existe una cuenta con ese correo, recibirás instrucciones para cambiar la contraseña.')
    setLoading(false)
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4">
      <section className="w-full max-w-md rounded-xl border bg-background p-6 shadow-sm">
        <header className="mb-6 space-y-1">
          <h1 className="text-2xl font-semibold">Recuperar contraseña</h1>
          <p className="text-sm text-muted-foreground">Te enviaremos un enlace seguro por correo.</p>
        </header>

        <form className="space-y-4" onSubmit={handleSubmit}>
          <label className="block space-y-1">
            <span className="text-sm font-medium">Correo electrónico</span>
            <input
              autoComplete="email"
              className="w-full rounded-md border px-3 py-2"
              onChange={(event) => setEmail(event.target.value)}
              required
              type="email"
              value={email}
            />
          </label>

          {message ? <p role="status" className="text-sm">{message}</p> : null}

          <button className="w-full rounded-md bg-primary px-4 py-2 text-primary-foreground" disabled={loading} type="submit">
            {loading ? 'Enviando…' : 'Enviar enlace'}
          </button>
        </form>
      </section>
    </main>
  )
}
