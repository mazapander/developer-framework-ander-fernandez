import { FormEvent, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { supabase } from '@/lib/supabase'

export function ResetPasswordPage() {
  const navigate = useNavigate()
  const [password, setPassword] = useState('')
  const [confirmation, setConfirmation] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError(null)

    if (password !== confirmation) {
      setError('Las contraseñas no coinciden.')
      return
    }

    setLoading(true)
    const { error: updateError } = await supabase.auth.updateUser({ password })

    if (updateError) {
      setError('No se ha podido actualizar la contraseña. Solicita un enlace nuevo.')
      setLoading(false)
      return
    }

    navigate('/login', { replace: true })
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4">
      <section className="w-full max-w-md rounded-xl border bg-background p-6 shadow-sm">
        <header className="mb-6 space-y-1">
          <h1 className="text-2xl font-semibold">Nueva contraseña</h1>
          <p className="text-sm text-muted-foreground">Utiliza al menos ocho caracteres.</p>
        </header>

        <form className="space-y-4" onSubmit={handleSubmit}>
          <label className="block space-y-1">
            <span className="text-sm font-medium">Contraseña nueva</span>
            <input autoComplete="new-password" className="w-full rounded-md border px-3 py-2" minLength={8} onChange={(event) => setPassword(event.target.value)} required type="password" value={password} />
          </label>
          <label className="block space-y-1">
            <span className="text-sm font-medium">Repetir contraseña</span>
            <input autoComplete="new-password" className="w-full rounded-md border px-3 py-2" minLength={8} onChange={(event) => setConfirmation(event.target.value)} required type="password" value={confirmation} />
          </label>

          {error ? <p role="alert" className="text-sm text-destructive">{error}</p> : null}

          <button className="w-full rounded-md bg-primary px-4 py-2 text-primary-foreground" disabled={loading} type="submit">
            {loading ? 'Actualizando…' : 'Guardar contraseña'}
          </button>
        </form>
      </section>
    </main>
  )
}
