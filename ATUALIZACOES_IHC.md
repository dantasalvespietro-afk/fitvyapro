# FITWAY — Atualização conforme Tarefas Principais (IHC)

Implementado no `lib/main.dart`:

1. Registro e acompanhamento do treino diário
- Campos de carga e repetições por exercício.
- Botões grandes para uso durante o treino.
- Cronômetro de descanso interativo após concluir série.
- Pausar/ajustar descanso (-15s/+30s) e pular descanso.
- Feedback háptico e feedback visual ao finalizar descanso.
- Possibilidade de trocar a ordem dos exercícios quando o equipamento estiver ocupado.
- Acesso à ficha/instruções do exercício.

2. Consulta de ficha e instrução de exercícios
- Nova tela "Ficha de Treino e Instruções".
- Tela detalhada de cada exercício.
- Demonstração/vídeo como área preparada para mídia.
- Orientações textuais, séries, descanso e equipamento.
- Alternativa de exercício quando o equipamento estiver ocupado.
- Indicação de legendas e instruções em texto para acessibilidade.

3. Agendamento de aulas coletivas
- Nova aba "Aulas" na navegação inferior.
- Seleção de data e filtro por modalidade.
- Exibição de instrutor, horário e vagas restantes.
- Status "Últimas vagas", "Esgotado" e reserva confirmada.
- Reserva e cancelamento.
- Lista de espera para turma lotada.
- Modal de confirmação e lembrete visual.

4. Evolução física
- Peso e percentual de gordura.
- Visualização de progressão de volume/carga semanal.

A implementação usa somente recursos já disponíveis no Flutter, sem adicionar dependências externas.


## Novas atualizações — versão solicitada

5. Modo normal sem personalização
- Adicionado o botão **"Pular personalização • Treino normal"** no check-in.
- O usuário também pode iniciar diretamente o treino normal pela tela "Meus Treinos".
- O modo normal usa `normalWorkout`, ignorando a adaptação por equipamentos/prontidão naquele fluxo.

6. Plano da academia / Gestor
- Criado o fluxo **Piloto x Final • FITWAY PRO**.
- Piloto: gratuito para demonstração.
- Final: **R$ 99,99/mês por academia**.
- Também foi adicionada opção anual de demonstração: **R$ 999,90/ano**.
- A tela deixa claro que a cobrança real ainda precisa ser conectada a um gateway/backend antes do lançamento comercial.

7. Biblioteca de 100 exercícios
- Adicionada uma biblioteca com **100 exercícios essenciais**.
- Cada exercício possui GIF local no projeto, busca, filtro por categoria e tela detalhada.
- Os GIFs incluídos nesta versão são animações instrucionais estilizadas geradas para o protótipo, evitando depender de mídia de terceiros.

8. Tutorial opcional
- Criado tutorial em páginas, com botão **Pular**.
- Acesso pelo login, Perfil do aluno e Perfil do gestor.
- Explica check-in, personalização, modo normal, GIFs, academias e planos.

9. Nova identidade visual
- O novo logo enviado foi adicionado em `assets/branding/fitway_logo.png`.
- O logo aparece na Splash, Login, Tutorial e tela de planos.
- O `pubspec.yaml` foi atualizado para incluir a pasta de assets.
