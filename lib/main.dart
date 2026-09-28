import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Supabase.initialize(
url: 'https://xslyoohesserczpqnwdm.supabase.co',
anonKey: 'sb_publishable_ESEm0Y8PQIp6z50N_p7_sA_162igD91',
);
runApp(const FITVYAApp());
}
// ============================================================================
// 1. PALETA DE CORES E TEMA FITVYA (DESIGN SYSTEM)
// ============================================================================
class AppColors {
static const background = Color(0xFF101010);
static const cardBackground = Color(0xFF1B1B1E);
static const primaryNeon = Color(0xFFCCFF00); // Verde Neon FITVYA
static const textPrimary = Colors.white;
static const textSecondary = Color(0xFFA0A0A0);
static const border = Color(0xFF2C2C30);
static const danger = Color(0xFFFF453A);
static const warning = Color(0xFFFF9F0A);
static const success = Color(0xFF30D158);
}
class FITVYAApp extends StatelessWidget {
const FITVYAApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'FITVYA PRO',
theme: ThemeData.dark().copyWith(
scaffoldBackgroundColor: AppColors.background,
colorScheme: const ColorScheme.dark(
primary: AppColors.primaryNeon,
surface: AppColors.cardBackground,
),
appBarTheme: const AppBarTheme(
backgroundColor: AppColors.background,
elevation: 0,
centerTitle: true,
titleTextStyle: TextStyle(
color: AppColors.textPrimary,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
builder: (context, child) {
return Container(
color: const Color(0xFF050505),
child: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 480),
child: child ?? const SizedBox(),
),
),
);
},
home: const SplashScreen(),
);
}
}
class FitVyaLogo extends StatelessWidget {
final double height;
final BoxFit fit;
const FitVyaLogo({super.key, this.height = 120, this.fit = BoxFit.contain});
@override
Widget build(BuildContext context) {
return Image.asset(
'assets/branding/fitvya_pro_logo.png',
height: height,
width: double.infinity,
fit: fit,
filterQuality: FilterQuality.high,
);
}
}
// ============================================================================
FITVYA PRO • main.dart atualizado • Página 3
// 2. MODELOS DE DADOS E ESTADO DA APLICAÇÃO UNIFICADO
// ============================================================================
class EquipmentItem {
final String id;
String name;
String category;
String brand;
String model;
String acquisitionDate;
bool isAvailable;
String statusMessage;
EquipmentItem({
required this.id,
required this.name,
required this.category,
this.brand = "Life Fitness",
this.model = "2024",
this.acquisitionDate = "10/06/2024",
this.isAvailable = true,
this.statusMessage = "Disponível para uso",
});
}
class MaintenanceItem {
final String id;
final String equipmentName;
final String problemType;
final String priority;
final String description;
final String date;
String status;
MaintenanceItem({
required this.id,
required this.equipmentName,
required this.problemType,
required this.priority,
required this.description,
required this.date,
this.status = 'Pendente',
});
}
class WorkoutHistoryItem {
final String date;
final String title;
final String duration;
final int exercisesCount;
final int totalSets;
final String totalVolumeKg;
final String ratingEmoji;
WorkoutHistoryItem({
required this.date,
required this.title,
required this.duration,
required this.exercisesCount,
this.totalSets = 18,
this.totalVolumeKg = "8.750 kg",
this.ratingEmoji = "⚡",
});
}
class ExerciseModel {
final String id;
final String name;
final String targetEquipment;
final String fallbackExercise;
final String normalSets;
final String lightSets;
final String defaultWeight;
final String restSeconds;
// Reservado para os GIFs licenciados que serão adicionados futuramente dentro do treino.
final String? licensedGifAsset;
ExerciseModel({
required this.id,
required this.name,
required this.targetEquipment,
required this.fallbackExercise,
required this.normalSets,
required this.lightSets,
required this.defaultWeight,
required this.restSeconds,
this.licensedGifAsset,
});
}
class GroupClassModel {
final String id;
final String name;
final String modality;
FITVYA PRO • main.dart atualizado • Página 4
final String instructor;
final String date;
final String time;
int availableSpots;
GroupClassModel({
required this.id,
required this.name,
required this.modality,
required this.instructor,
required this.date,
required this.time,
required this.availableSpots,
});
}
class AppState extends ChangeNotifier {
static final AppState instance = AppState._internal();
AppState._internal();
// Dados Globais / Aluno
String userName = "Ricardo";
String userEmail = "ricardo.silva@email.com";
String userPassword = "123456"; // senha de demonstração cadastrada no fluxo atual
String gestorPassword = "123456"; // senha do gestor cadastrada no fluxo de acesso administrativo
String mainGoal = "Hipertrofia & Definição";
// Preferências usadas pelo motor de personalização do treino.
String bodyProfile = "Prefiro não informar";
String trainingLevel = "Intermediário";
String trainingFrequency = "4x por semana";
final Set<String> muscleFocus = <String>{"Desenvolvimento equilibrado"};
final Set<String> limitations = <String>{"Nenhuma"};
bool isGestor = false;
// Dados da Academia (Gestor)
String gymName = "Academia Fit Life";
String gymCnpj = "12.345.678/0001-90";
String gymAddress = "Av. das Nações, 1234 - São Paulo, SP";
String gymHours = "Seg - Sex: 06:00 - 23:00 | Sáb: 08:00 - 18:00";
int activeStudentsCount = 42;
String gymCapacityText = "65% (Moderada)";
// Assinatura B2B da academia (interface/lógica do piloto; cobrança real depende do backend).
String gestorPlan = "Piloto";
bool gestorAnnualBilling = false;
static const double gestorMonthlyPrice = 99.99;
static const double gestorAnnualPrice = 999.90;
bool get gestorPlanActive => gestorPlan == "Final";
double get currentPlanPrice => gestorAnnualBilling ? gestorAnnualPrice : gestorMonthlyPrice;
void activateGestorPlan({required bool annual}) {
gestorPlan = "Final";
gestorAnnualBilling = annual;
notifyListeners();
}
void returnToPilotPlan() {
gestorPlan = "Piloto";
gestorAnnualBilling = false;
notifyListeners();
}
// Avaliação de Prontidão Física Diária (Aluno)
bool hasEvaluatedToday = false;
double energy = 7.0;
double sleep = 5.0;
double soreness = 3.0;
double disposition = 8.0;
double readinessScore = 0.72;
void calculateReadiness({
required double newEnergy,
required double newSleep,
required double newSoreness,
required double newDisposition,
}) {
energy = newEnergy;
sleep = newSleep;
soreness = newSoreness;
disposition = newDisposition;
double raw = (energy + sleep + (10 - soreness) + disposition) / 40.0;
readinessScore = raw.clamp(0.0, 1.0);
hasEvaluatedToday = true;
notifyListeners();
}
// Academias do Aluno
String selectedGym = "Academia Fit Life";
List<String> userGyms = ["Academia Fit Life", "Body Center", "Strong Gym"];
// Equipamentos disponíveis por academia. O treino do aluno usa esta relação
// para indicar se o aparelho da série está disponível e sugerir alternativa.
FITVYA PRO • main.dart atualizado • Página 5
final Map<String, Set<String>> gymEquipmentMap = {
"Academia Fit Life": {
"Máquinas para Peito", "Leg Press 45°", "Cubos e Polias", "Cadeira Extensora",
"Esteiras", "Bicicletas", "Hack Squat", "Halteres",
},
"Body Center": {
"Máquinas para Peito", "Leg Press 45°", "Halteres", "Esteiras", "Bicicletas",
},
"Strong Gym": {
"Cubos e Polias", "Cadeira Extensora", "Halteres", "Hack Squat", "Esteiras",
},
};
bool hasEquipmentForSelectedGym(String equipment) {
return gymEquipmentMap[selectedGym]?.contains(equipment) ?? false;
}
void selectGym(String gym) {
selectedGym = gym;
notifyListeners();
}
void addGym(String name) {
userGyms.add(name);
selectedGym = name;
notifyListeners();
}
// Equipamentos da Academia
List<EquipmentItem> gymEquipments = [
EquipmentItem(id: "1", name: "Esteiras", category: "Cardio", isAvailable: true),
EquipmentItem(id: "2", name: "Bicicletas", category: "Cardio", isAvailable: true),
EquipmentItem(id: "3", name: "Leg Press 45°", category: "Musculação", isAvailable: true),
EquipmentItem(id: "4", name: "Hack Squat", category: "Musculação", isAvailable: true),
EquipmentItem(id: "5", name: "Smith Machine", category: "Musculação", isAvailable: true),
EquipmentItem(id: "6", name: "Halteres", category: "Pesos Livres", isAvailable: true),
EquipmentItem(id: "7", name: "Cubos e Polias", category: "Musculação", isAvailable: true),
EquipmentItem(id: "8", name: "Máquinas para Peito", category: "Musculação", isAvailable: true),
EquipmentItem(id: "9", name: "Cadeira Extensora", category: "Musculação", isAvailable: false, statusMessage: "Em manutenção"),
];
void toggleEquipment(String id) {
final eq = gymEquipments.firstWhere((e) => e.id == id);
eq.isAvailable = !eq.isAvailable;
eq.statusMessage = eq.isAvailable ? "Disponível para uso" : "Em manutenção";
notifyListeners();
}
void addEquipment(EquipmentItem item) {
gymEquipments.add(item);
notifyListeners();
}
void updateEquipment(EquipmentItem updated) {
final index = gymEquipments.indexWhere((e) => e.id == updated.id);
if (index != -1) {
gymEquipments[index] = updated;
notifyListeners();
}
}
void removeEquipment(String id) {
gymEquipments.removeWhere((e) => e.id == id);
notifyListeners();
}
// Manutenções (Gestor)
List<MaintenanceItem> maintenanceList = [
MaintenanceItem(id: "1", equipmentName: "Cadeira Extensora", problemType: "Cabo de aço rompidos", priority: "Alta", description: "Nece
trocar o cabo de aço do peso principal.", date: "18/08/2025 às 09:15", status: "Pendente"),
MaintenanceItem(id: "2", equipmentName: "Esteira Profissional", problemType: "Lona desgastada", priority: "Média", description: "Ajust
lubrificação e troca do painel numérico.", date: "12/08/2025 às 14:30", status: "Em andamento"),
MaintenanceItem(id: "3", equipmentName: "Puxada Alta", problemType: "Roldana travada", priority: "Baixa", description: "Roldana superi
fazendo barulho.", date: "11/08/2025 às 10:00", status: "Concluída"),
];
void addMaintenance(MaintenanceItem item) {
maintenanceList.insert(0, item);
notifyListeners();
}
// Exercícios do Treino
List<ExerciseModel> currentWorkoutExercises = [
ExerciseModel(id: "1", name: "Supino Reto", targetEquipment: "Máquinas para Peito", fallbackExercise: "Supino Reto com Halteres", norm
"3 de 4 • 10-12 rep", lightSets: "2 de 3 • 10 rep", defaultWeight: "60 kg", restSeconds: "60s"),
ExerciseModel(id: "2", name: "Leg Press 45°", targetEquipment: "Leg Press 45°", fallbackExercise: "Agachamento com Halteres", normalSe
x 10", lightSets: "2 x 10", defaultWeight: "120 kg", restSeconds: "90s"),
ExerciseModel(id: "3", name: "Mesa Flexora", targetEquipment: "Cubos e Polias", fallbackExercise: "Stiff com Halteres", normalSets: "4
lightSets: "2 x 12", defaultWeight: "45 kg", restSeconds: "60s"),
ExerciseModel(id: "4", name: "Cadeira Extensora", targetEquipment: "Cadeira Extensora", fallbackExercise: "Passada com Halteres", norm
"4 x 12", lightSets: "2 x 12", defaultWeight: "50 kg", restSeconds: "60s"),
ExerciseModel(id: "5", name: "Panturrilha Sentado", targetEquipment: "Cubos e Polias", fallbackExercise: "Panturrilha em Pé com Halter
normalSets: "4 x 15", lightSets: "2 x 15", defaultWeight: "70 kg", restSeconds: "45s"),
FITVYA PRO • main.dart atualizado • Página 6
];
// Motor de personalização: combina objetivo, perfil corporal (opcional),
// foco muscular, nível, frequência e limitações. Sexo/perfil nunca define o treino sozinho.
List<ExerciseModel> get personalizedWorkout {
final focus = muscleFocus;
final bool lowerFocus = focus.contains("Glúteos") || focus.contains("Pernas");
final bool upperFocus = focus.contains("Peito") || focus.contains("Costas") || focus.contains("Ombros") || focus.contains("Braços");
final bool balanced = focus.contains("Desenvolvimento equilibrado") || (!lowerFocus && !upperFocus);
final List<ExerciseModel> lower = [
ExerciseModel(id: "p1", name: "Hip Thrust", targetEquipment: "Cubos e Polias", fallbackExercise: "Elevação de Quadril", normalSets:
8-12", lightSets: "2 x 10", defaultWeight: "50 kg", restSeconds: "90s"),
ExerciseModel(id: "p2", name: "Agachamento", targetEquipment: "Hack Squat", fallbackExercise: "Agachamento com Halteres", normalSets
8-10", lightSets: "2 x 10", defaultWeight: "60 kg", restSeconds: "90s"),
ExerciseModel(id: "p3", name: "Leg Press 45°", targetEquipment: "Leg Press 45°", fallbackExercise: "Agachamento Goblet", normalSets:
10-12", lightSets: "2 x 10", defaultWeight: "120 kg", restSeconds: "90s"),
ExerciseModel(id: "p4", name: "Cadeira Extensora", targetEquipment: "Cadeira Extensora", fallbackExercise: "Avanço com Halteres",
normalSets: "3 x 12-15", lightSets: "2 x 12", defaultWeight: "50 kg", restSeconds: "60s"),
ExerciseModel(id: "p5", name: "Mesa Flexora", targetEquipment: "Cubos e Polias", fallbackExercise: "Stiff com Halteres", normalSets:
10-12", lightSets: "2 x 10", defaultWeight: "45 kg", restSeconds: "60s"),
];
final List<ExerciseModel> upper = [
ExerciseModel(id: "u1", name: "Supino Reto", targetEquipment: "Máquinas para Peito", fallbackExercise: "Supino com Halteres", normal
"4 x 8-12", lightSets: "2 x 10", defaultWeight: "60 kg", restSeconds: "75s"),
ExerciseModel(id: "u2", name: "Remada Baixa", targetEquipment: "Cubos e Polias", fallbackExercise: "Remada com Halteres", normalSets
8-12", lightSets: "2 x 10", defaultWeight: "50 kg", restSeconds: "75s"),
ExerciseModel(id: "u3", name: "Puxada Alta", targetEquipment: "Cubos e Polias", fallbackExercise: "Remada com Halteres", normalSets:
10-12", lightSets: "2 x 10", defaultWeight: "45 kg", restSeconds: "60s"),
ExerciseModel(id: "u4", name: "Desenvolvimento de Ombros", targetEquipment: "Halteres", fallbackExercise: "Desenvolvimento com Halte
normalSets: "3 x 10-12", lightSets: "2 x 10", defaultWeight: "18 kg", restSeconds: "60s"),
ExerciseModel(id: "u5", name: "Rosca + Tríceps", targetEquipment: "Halteres", fallbackExercise: "Rosca + Tríceps com Halteres", norm
"3 x 12 + 12", lightSets: "2 x 10 + 10", defaultWeight: "12 kg", restSeconds: "60s"),
];
List<ExerciseModel> selected;
if (lowerFocus && !upperFocus) {
selected = [...lower];
} else if (upperFocus && !lowerFocus) {
selected = [...upper];
} else if (balanced || lowerFocus || upperFocus) {
if (bodyProfile == "Feminino") {
selected = [lower[0], lower[2], upper[0], upper[1], lower[3]];
} else if (bodyProfile == "Masculino") {
selected = [upper[0], upper[1], upper[2], lower[1], upper[4]];
} else {
selected = [lower[0], lower[1], upper[0], upper[1], lower[3]];
}
} else {
selected = [...currentWorkoutExercises];
}
// Ajusta volume/intenção de acordo com experiência e objetivo.
if (trainingLevel == "Iniciante") {
selected = selected.map((ex) => ExerciseModel(
id: ex.id, name: ex.name, targetEquipment: ex.targetEquipment, fallbackExercise: ex.fallbackExercise,
normalSets: ex.lightSets, lightSets: ex.lightSets, defaultWeight: ex.defaultWeight, restSeconds: ex.restSeconds,
)).toList();
}
if (mainGoal == "Ganho de Força") {
selected = selected.map((ex) => ExerciseModel(
id: ex.id, name: ex.name, targetEquipment: ex.targetEquipment, fallbackExercise: ex.fallbackExercise,
normalSets: "4 x 4-8", lightSets: "2 x 8", defaultWeight: ex.defaultWeight, restSeconds: "120s",
)).toList();
}
if (limitations.contains("Joelho")) {
selected = selected.map((ex) {
if (ex.name == "Leg Press 45°" || ex.name == "Agachamento" || ex.name == "Cadeira Extensora") {
return ExerciseModel(id: ex.id, name: "Hip Thrust", targetEquipment: "Cubos e Polias", fallbackExercise: "Elevação de Quadril",
normalSets: ex.normalSets, lightSets: ex.lightSets, defaultWeight: ex.defaultWeight, restSeconds: ex.restSeconds);
}
return ex;
}).toList();
}
return selected;
}
// O treino personalizado também respeita os equipamentos da academia.
List<ExerciseModel> get workoutForSelectedGym {
return personalizedWorkout.map((ex) {
if (hasEquipmentForSelectedGym(ex.targetEquipment)) return ex;
return ExerciseModel(
id: ex.id, name: ex.fallbackExercise, targetEquipment: "Halteres", fallbackExercise: ex.fallbackExercise,
normalSets: ex.normalSets, lightSets: ex.lightSets, defaultWeight: ex.defaultWeight, restSeconds: ex.restSeconds,
);
}).toList();
}
// Modo normal: ignora toda a personalização e usa o treino padrão.
FITVYA PRO • main.dart atualizado • Página 7
List<ExerciseModel> get normalWorkout => currentWorkoutExercises;
// Histórico de Treinos
List<WorkoutHistoryItem> workoutHistory = [
WorkoutHistoryItem(date: "12/08/2026", title: "Peito + Tríceps", duration: "01:02:15", exercisesCount: 6, totalSets: 18, totalVolumeKg
"8.750 kg", ratingEmoji: "⚡"),
WorkoutHistoryItem(date: "10/08/2026", title: "Costas + Bíceps", duration: "01:15:30", exercisesCount: 7, totalSets: 21, totalVolumeKg
"9.200 kg", ratingEmoji: "⚡"),
WorkoutHistoryItem(date: "08/08/2026", title: "Pernas Completo", duration: "01:10:45", exercisesCount: 8, totalSets: 24, totalVolumeKg
"12.400 kg", ratingEmoji: "⚡"),
];
void addWorkoutHistory(WorkoutHistoryItem item) {
workoutHistory.insert(0, item);
notifyListeners();
}
// Aulas coletivas / agenda
List<GroupClassModel> groupClasses = [
GroupClassModel(id: "a1", name: "Spinning", modality: "Spinning", instructor: "Mariana Costa", date: "18/08/2026", time: "07:00",
availableSpots: 2),
GroupClassModel(id: "a2", name: "Pilates", modality: "Pilates", instructor: "Fernanda Lima", date: "18/08/2026", time: "09:00",
availableSpots: 8),
GroupClassModel(id: "a3", name: "Cross Training", modality: "Cross", instructor: "Lucas Almeida", date: "18/08/2026", time: "18:30",
availableSpots: 0),
GroupClassModel(id: "a4", name: "Funcional", modality: "Funcional", instructor: "Rafael Souza", date: "19/08/2026", time: "19:00",
availableSpots: 1),
GroupClassModel(id: "a5", name: "Spinning", modality: "Spinning", instructor: "Mariana Costa", date: "20/08/2026", time: "08:00",
availableSpots: 10),
];
final Set<String> reservedClasses = <String>{};
final Set<String> waitlistedClasses = <String>{};
bool reserveClass(String id) {
if (reservedClasses.contains(id)) return false;
final aula = groupClasses.firstWhere((e) => e.id == id);
if (aula.availableSpots <= 0) return false;
aula.availableSpots--;
reservedClasses.add(id);
notifyListeners();
return true;
}
void cancelClass(String id) {
if (!reservedClasses.remove(id)) return;
final aula = groupClasses.firstWhere((e) => e.id == id);
aula.availableSpots++;
notifyListeners();
}
void joinWaitlist(String id) {
waitlistedClasses.add(id);
notifyListeners();
}
void leaveWaitlist(String id) {
waitlistedClasses.remove(id);
notifyListeners();
}
bool deleteAccount(String password) {
if (password != userPassword) return false;
// Limpa os dados locais da conta de demonstração.
userName = "";
userEmail = "";
userPassword = "";
mainGoal = "";
hasEvaluatedToday = false;
reservedClasses.clear();
waitlistedClasses.clear();
workoutHistory.clear();
notifyListeners();
return true;
}
bool deleteGestorAccount(String password) {
if (password != gestorPassword) return false;
// Remove os dados da conta administrativa de demonstração.
isGestor = false;
gymName = "";
gymCnpj = "";
gymAddress = "";
gymHours = "";
activeStudentsCount = 0;
gymCapacityText = "";
notifyListeners();
return true;
}
}
// ============================================================================
// 3. TELAS DE INICIALIZAÇÃO & AUTENTICAÇÃO
FITVYA PRO • main.dart atualizado • Página 8
// ============================================================================
class SplashScreen extends StatefulWidget {
const SplashScreen({super.key});
@override
State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
@override
void initState() {
super.initState();
Future.delayed(const Duration(seconds: 2), () {
if (mounted) {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const LoginScreen()),
);
}
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const FitVyaLogo(height: 150),
const SizedBox(height: 10),
const SizedBox(height: 8),
const Text(
"Treinos Inteligentes & Gestão de Academias",
style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
),
const SizedBox(height: 48),
const CircularProgressIndicator(color: AppColors.primaryNeon),
],
),
),
);
}
}
class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});
@override
State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
bool isGestorMode = false;
final emailController = TextEditingController(text: "ricardo@email.com");
final passwordController = TextEditingController(text: "123456");
@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 40),
const Center(child: FitVyaLogo(height: 120)),
const SizedBox(height: 8),
const Center(
child: Text("Bem-vindo de volta!", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
),
const SizedBox(height: 8),
TextButton.icon(
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialScreen())),
icon: const Icon(Icons.school_outlined, color: AppColors.primaryNeon, size: 18),
label: const Text("Ver tutorial opcional", style: TextStyle(color: AppColors.primaryNeon)),
),
const SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
ChoiceChip(
label: const Text("Aluno"),
selected: !isGestorMode,
selectedColor: AppColors.primaryNeon,
labelStyle: TextStyle(color: !isGestorMode ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
onSelected: (val) => setState(() => isGestorMode = !val),
),
const SizedBox(width: 12),
ChoiceChip(
label: const Text("Gestor de Academia"),
selected: isGestorMode,
FITVYA PRO • main.dart atualizado • Página 9
selectedColor: AppColors.primaryNeon,
labelStyle: TextStyle(color: isGestorMode ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
onSelected: (val) => setState(() => isGestorMode = val),
),
],
),
const SizedBox(height: 24),
TextField(
controller: emailController,
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
labelText: "E-mail",
prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryNeon),
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
),
),
const SizedBox(height: 16),
TextField(
controller: passwordController,
obscureText: true,
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
labelText: "Senha",
prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryNeon),
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
),
),
const SizedBox(height: 12),
Align(
alignment: Alignment.centerRight,
child: TextButton(
onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
},
child: const Text("Esqueceu a senha?", style: TextStyle(color: AppColors.textSecondary)),
),
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: () {
final state = AppState.instance;
if (emailController.text.trim().isNotEmpty &&
state.userEmail.isNotEmpty &&
emailController.text.trim() != state.userEmail) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-mail não cadastrado.")));
return;
}
if (!isGestorMode && state.userPassword.isNotEmpty && passwordController.text != state.userPassword) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Senha incorreta.")));
return;
}
state.isGestor = isGestorMode;
if (isGestorMode) {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GestorMainShellNav()));
} else {
if (!AppState.instance.hasEvaluatedToday) {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReadinessCheckInScreen()));
} else {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellNav()));
}
}
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: Text(
isGestorMode ? "Entrar como Gestor" : "Entrar",
style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
),
const SizedBox(height: 32),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text("Não tem conta? ", style: TextStyle(color: AppColors.textSecondary)),
GestureDetector(
onTap: () {
if (isGestorMode) {
Navigator.push(context, MaterialPageRoute(builder: (_) => const GestorRegisterFlowScreen()));
} else {
Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
}
},
child: const Text(
"Cadastre-se",
style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold),
FITVYA PRO • main.dart atualizado • Página 10
),
),
],
),
],
),
),
),
);
}
}
class ForgotPasswordScreen extends StatelessWidget {
const ForgotPasswordScreen({super.key});
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Recuperar Senha")),
body: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Icon(Icons.lock_reset, size: 72, color: AppColors.primaryNeon),
const SizedBox(height: 16),
const Text(
"Esqueceu sua senha?",
textAlign: TextAlign.center,
style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
const Text(
"Informe seu e-mail cadastrado e enviaremos o link de recuperação.",
textAlign: TextAlign.center,
style: TextStyle(color: AppColors.textSecondary),
),
const SizedBox(height: 32),
TextField(
decoration: InputDecoration(
labelText: "E-mail de cadastro",
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
),
const SizedBox(height: 24),
ElevatedButton(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Instruções enviadas para seu e-mail!")));
Navigator.pop(context);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: const Text("ENVIAR INSTRUÇÕES", style: TextStyle(fontWeight: FontWeight.bold)),
),
],
),
),
);
}
}
class RegisterScreen extends StatefulWidget {
const RegisterScreen({super.key});
@override
State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
String selectedGoal = "Hipertrofia & Definição";
String selectedGym = AppState.instance.selectedGym;
String bodyProfile = "Prefiro não informar";
String trainingLevel = "Iniciante";
String trainingFrequency = "3x por semana";
Set<String> muscleFocus = {"Desenvolvimento equilibrado"};
Set<String> limitations = {"Nenhuma"};
bool termsAccepted = true;
final nameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final List<String> focusOptions = const [
"Desenvolvimento equilibrado",
"Glúteos",
"Pernas",
"Peito",
FITVYA PRO • main.dart atualizado • Página 11
"Costas",
"Ombros",
"Braços",
"Abdômen",
];
final List<String> limitationOptions = const [
"Nenhuma",
"Joelho",
"Ombro",
"Lombar",
"Outra",
];
@override
void dispose() {
nameController.dispose();
emailController.dispose();
passwordController.dispose();
super.dispose();
}
Widget _title(String text, String subtitle) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
],
),
);
}
Widget _chip(String label, bool selected, VoidCallback onTap) {
return FilterChip(
label: Text(label),
selected: selected,
onSelected: (_) => onTap(),
selectedColor: AppColors.primaryNeon,
checkmarkColor: Colors.black,
labelStyle: TextStyle(color: selected ? Colors.black : AppColors.textPrimary, fontWeight: FontWeight.w600),
backgroundColor: AppColors.cardBackground,
);
}
void _toggleFocus(String item) {
setState(() {
if (item == "Desenvolvimento equilibrado") {
muscleFocus = {item};
} else {
muscleFocus.remove("Desenvolvimento equilibrado");
if (muscleFocus.contains(item)) {
muscleFocus.remove(item);
} else {
muscleFocus.add(item);
}
if (muscleFocus.isEmpty) muscleFocus.add("Desenvolvimento equilibrado");
}
});
}
void _toggleLimitation(String item) {
setState(() {
if (item == "Nenhuma") {
limitations = {item};
} else {
limitations.remove("Nenhuma");
if (limitations.contains(item)) {
limitations.remove(item);
} else {
limitations.add(item);
}
if (limitations.isEmpty) limitations.add("Nenhuma");
}
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Criar Conta (Aluno)")),
body: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Text("Junte-se ao FITVYA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
const Text("Monte seu perfil para o FITVYA adaptar o treino ao seu objetivo.", style: TextStyle(color: AppColors.textSecondary
const SizedBox(height: 24),
FITVYA PRO • main.dart atualizado • Página 12
TextField(
controller: nameController,
decoration: InputDecoration(
labelText: "Nome Completo",
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
),
const SizedBox(height: 16),
TextField(
controller: emailController,
decoration: InputDecoration(
labelText: "E-mail",
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
),
const SizedBox(height: 16),
TextField(
controller: passwordController,
obscureText: true,
decoration: InputDecoration(
labelText: "Senha",
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
),
const SizedBox(height: 16),
DropdownButtonFormField<String>(
value: selectedGym,
dropdownColor: AppColors.cardBackground,
decoration: InputDecoration(
labelText: "Qual é a sua academia?",
prefixIcon: const Icon(Icons.fitness_center, color: AppColors.primaryNeon),
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
items: AppState.instance.userGyms
.map((gym) => DropdownMenuItem(value: gym, child: Text(gym)))
.toList(),
onChanged: (val) {
if (val != null) setState(() => selectedGym = val);
},
),
const SizedBox(height: 8),
const Text(
"O treino também respeita os equipamentos disponíveis nessa academia.",
style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
const SizedBox(height: 16),
DropdownButtonFormField<String>(
value: selectedGoal,
dropdownColor: AppColors.cardBackground,
decoration: InputDecoration(
labelText: "Objetivo Principal",
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
),
items: [
"Hipertrofia & Definição",
"Ganho de Força",
"Perda de Peso / Emagrecimento",
"Condicionamento Físico",
"Saúde e Qualidade de Vida",
].map((goal) => DropdownMenuItem(value: goal, child: Text(goal))).toList(),
onChanged: (val) {
if (val != null) setState(() => selectedGoal = val);
},
),
const SizedBox(height: 28),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
border: Border.all(color: AppColors.primaryNeon, width: 1.2),
borderRadius: BorderRadius.circular(16),
color: AppColors.cardBackground,
),
child: const Row(
children: [
Icon(Icons.auto_awesome, color: AppColors.primaryNeon),
SizedBox(width: 10),
Expanded(
child: Text(
"PERSONALIZAÇÃO AVANÇADA\nQuanto mais informações você passar, mais o FITVYA consegue ajustar o treino.",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
),
),
],
FITVYA PRO • main.dart atualizado • Página 13
),
),
const SizedBox(height: 20),
_title("Perfil corporal (opcional)", "É apenas um fator de contexto. Não define o treino sozinho."),
Wrap(spacing: 8, runSpacing: 8, children: [
_chip("Masculino", bodyProfile == "Masculino", () => setState(() => bodyProfile = "Masculino")),
_chip("Feminino", bodyProfile == "Feminino", () => setState(() => bodyProfile = "Feminino")),
_chip("Prefiro não informar", bodyProfile == "Prefiro não informar", () => setState(() => bodyProfile = "Prefiro não informa
]),
const SizedBox(height: 20),
_title("Nível de treino", "Define volume e complexidade iniciais."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in const ["Iniciante", "Intermediário", "Avançado"])
_chip(item, trainingLevel == item, () => setState(() => trainingLevel = item)),
]),
const SizedBox(height: 20),
_title("Frequência semanal", "Quantos dias você pretende treinar?"),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in const ["2x por semana", "3x por semana", "4x por semana", "5x por semana", "6x por semana"])
_chip(item, trainingFrequency == item, () => setState(() => trainingFrequency = item)),
]),
const SizedBox(height: 20),
_title("O que você quer desenvolver?", "Escolha as regiões que devem receber mais atenção."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in focusOptions)
_chip(item, muscleFocus.contains(item), () => _toggleFocus(item)),
]),
const SizedBox(height: 20),
_title("Limitações ou cuidados", "Ajuda a reduzir exercícios inadequados no futuro."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in limitationOptions)
_chip(item, limitations.contains(item), () => _toggleLimitation(item)),
]),
const SizedBox(height: 14),
const Text(
"Exemplo: uma pessoa pode escolher Feminino + Hipertrofia + 5x/semana + Glúteos/Pernas, enquanto outra pode escolher Masculi
Força + 4x/semana + Peito/Costas. O FITVYA combina esses dados em vez de usar uma regra única por sexo.",
style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
const SizedBox(height: 20),
Row(
children: [
Checkbox(
value: termsAccepted,
activeColor: AppColors.primaryNeon,
checkColor: Colors.black,
onChanged: (val) => setState(() => termsAccepted = val ?? true),
),
const Expanded(
child: Text("Li e concordo com os Termos de Uso e Política de Privacidade.", style: TextStyle(fontSize: 12, color:
AppColors.textSecondary)),
)
],
),
const SizedBox(height: 24),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
onPressed: () async {
if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preencha nome, e-mail e senha.")));
return;
}
if (!termsAccepted) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aceite os termos para continuar.")));
return;
}
if (passwordController.text.length < 6) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A senha precisa ter pelo menos 6 caracteres."))
return;
}
final name = nameController.text.trim();
final email = emailController.text.trim();
final password = passwordController.text;
try {
debugPrint("FITVYA: iniciando cadastro para $email");
final response = await Supabase.instance.client.auth.signUp(
email: email,
password: password,
data: {
'display_name': name,
'name': name,
'role': 'aluno',
'gym': selectedGym,
'main_goal': selectedGoal,
'body_profile': bodyProfile,
FITVYA PRO • main.dart atualizado • Página 14
'training_level': trainingLevel,
'training_frequency': trainingFrequency,
'muscle_focus': muscleFocus.toList(),
'limitations': limitations.toList(),
},
);
debugPrint("FITVYA: cadastro concluído. user=${response.user?.id}, session=${response.session != null}");
if (response.user == null) {
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("O cadastro não criou o usuário. Verifique as configurações do Supabase.")),
);
return;
}
final state = AppState.instance;
state.userName = name;
state.userEmail = email;
state.userPassword = password;
state.mainGoal = selectedGoal;
state.bodyProfile = bodyProfile;
state.trainingLevel = trainingLevel;
state.trainingFrequency = trainingFrequency;
state.muscleFocus
..clear()
..addAll(muscleFocus.isEmpty ? {"Desenvolvimento equilibrado"} : muscleFocus);
state.limitations
..clear()
..addAll(limitations.isEmpty ? {"Nenhuma"} : limitations);
state.selectGym(selectedGym);
state.hasEvaluatedToday = false;
state.notifyListeners();
if (!mounted) return;
final message = response.session == null
? "Conta criada! Confirme seu e-mail se o Supabase solicitar."
: "Conta criada com sucesso!";
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(message)),
);
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const ReadinessCheckInScreen()),
);
} on AuthException catch (e) {
debugPrint("FITVYA: erro de autenticação: ${e.message}");
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Erro no cadastro: ${e.message}")),
);
} catch (e) {
debugPrint("FITVYA: erro inesperado no cadastro: $e");
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Erro inesperado no cadastro: $e")),
);
}
},
child: const Text("CRIAR CONTA E GERAR MEU TREINO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
),
],
),
),
);
}
}
class GestorRegisterFlowScreen extends StatefulWidget {
const GestorRegisterFlowScreen({super.key});
@override
State<GestorRegisterFlowScreen> createState() => _GestorRegisterFlowScreenState();
}
class _GestorRegisterFlowScreenState extends State<GestorRegisterFlowScreen> {
int currentStep = 1;
final gymNameCtrl = TextEditingController(text: "Academia Alpha");
final cnpjCtrl = TextEditingController(text: "12.345.678/0001-90");
final categoryCtrl = TextEditingController(text: "Musculação & Funcional");
final cepCtrl = TextEditingController(text: "01000-000");
final addressCtrl = TextEditingController(text: "Av. das Nações, 1234");
final numberCtrl = TextEditingController(text: "123");
final neighborhoodCtrl = TextEditingController(text: "Bairro Central");
final cityCtrl = TextEditingController(text: "São Paulo");
final stateCtrl = TextEditingController(text: "SP");
final gestorPasswordCtrl = TextEditingController();
final gestorPasswordConfirmCtrl = TextEditingController();
@override
FITVYA PRO • main.dart atualizado • Página 15
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(_getStepTitle()),
leading: IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: () {
if (currentStep > 1) {
setState(() => currentStep--);
} else {
Navigator.pop(context);
}
},
),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: _buildCurrentStepContent(),
),
),
);
}
String _getStepTitle() {
switch (currentStep) {
case 1: return "Cadastrar Academia (1/4)";
case 2: return "Cadastrar Academia (2/4)";
case 3: return "Cadastrar Academia (3/4)";
case 4: return "Senha e Resumo (4/4)";
default: return "Cadastro Gestor";
}
}
Widget _buildCurrentStepContent() {
switch (currentStep) {
case 1:
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Dados da Academia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 20),
TextField(controller: gymNameCtrl, decoration: const InputDecoration(labelText: "Nome da Academia")),
const SizedBox(height: 16),
TextField(controller: cnpjCtrl, decoration: const InputDecoration(labelText: "CNPJ")),
const SizedBox(height: 16),
TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Categoria")),
const SizedBox(height: 32),
ElevatedButton(
onPressed: () => setState(() => currentStep = 2),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, minimumSize: const
Size.fromHeight(50)),
child: const Text("Próximo", style: TextStyle(fontWeight: FontWeight.bold)),
),
],
);
case 2:
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Endereço", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 16),
TextField(controller: cepCtrl, decoration: const InputDecoration(labelText: "CEP")),
const SizedBox(height: 16),
TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Endereço (Rua, Av.)")),
const SizedBox(height: 16),
Row(
children: [
Expanded(child: TextField(controller: numberCtrl, decoration: const InputDecoration(labelText: "Número"))),
const SizedBox(width: 12),
const Expanded(child: TextField(decoration: InputDecoration(labelText: "Complemento"))),
],
),
const SizedBox(height: 16),
TextField(controller: neighborhoodCtrl, decoration: const InputDecoration(labelText: "Bairro")),
const SizedBox(height: 16),
Row(
children: [
Expanded(flex: 2, child: TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: "Cidade"))),
const SizedBox(width: 12),
Expanded(flex: 1, child: TextField(controller: stateCtrl, decoration: const InputDecoration(labelText: "Estado"))),
],
),
const SizedBox(height: 32),
ElevatedButton(
onPressed: () => setState(() => currentStep = 3),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, minimumSize: const
Size.fromHeight(50)),
child: const Text("Próximo", style: TextStyle(fontWeight: FontWeight.bold)),
),
],
);
case 3:
FITVYA PRO • main.dart atualizado • Página 16
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Horário de Funcionamento", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 16),
const TextField(decoration: InputDecoration(labelText: "Horário de abertura", hintText: "06:00")),
const SizedBox(height: 16),
const TextField(decoration: InputDecoration(labelText: "Horário de fechamento", hintText: "23:00")),
const SizedBox(height: 32),
ElevatedButton(
onPressed: () => setState(() => currentStep = 4),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, minimumSize: const
Size.fromHeight(50)),
child: const Text("Próximo", style: TextStyle(fontWeight: FontWeight.bold)),
),
],
);
case 4:
default:
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.border),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(gymNameCtrl.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text("CNPJ: ${cnpjCtrl.text}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
Text("${addressCtrl.text}, ${numberCtrl.text} - ${cityCtrl.text} / ${stateCtrl.text}", style: const TextStyle(color:
AppColors.textSecondary, fontSize: 13)),
],
),
),
const SizedBox(height: 24),
const Text("Criar senha do gestor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
const Text("Essa senha será usada para entrar como gestor e confirmar a exclusão da conta.", style: TextStyle(color:
AppColors.textSecondary)),
const SizedBox(height: 16),
TextField(
controller: gestorPasswordCtrl,
obscureText: true,
decoration: const InputDecoration(labelText: "Criar senha", prefixIcon: Icon(Icons.lock_outline)),
),
const SizedBox(height: 12),
TextField(
controller: gestorPasswordConfirmCtrl,
obscureText: true,
decoration: const InputDecoration(labelText: "Confirmar senha", prefixIcon: Icon(Icons.lock_reset_outlined)),
),
const SizedBox(height: 24),
ElevatedButton(
onPressed: () {
final senha = gestorPasswordCtrl.text.trim();
final confirmacao = gestorPasswordConfirmCtrl.text.trim();
if (senha.length < 6) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A senha deve ter pelo menos 6 caracteres.")));
return;
}
if (senha != confirmacao) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("As senhas não coincidem.")));
return;
}
AppState.instance.gymName = gymNameCtrl.text;
AppState.instance.gestorPassword = senha;
AppState.instance.isGestor = true;
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GestorMainShellNav()));
},
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, minimumSize: const
Size.fromHeight(50)),
child: const Text("Finalizar Cadastro", style: TextStyle(fontWeight: FontWeight.bold)),
),
],
);
}
}
}
// ============================================================================
// 4. FLUXO DO ALUNO (TELA PRINCIPAL, TREINOS, CHECK-IN, HISTÓRICO)
// ============================================================================
class PersonalizationScreen extends StatefulWidget {
final bool isFirstSetup;
const PersonalizationScreen({super.key, this.isFirstSetup = false});
@override
FITVYA PRO • main.dart atualizado • Página 17
State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}
class _PersonalizationScreenState extends State<PersonalizationScreen> {
late String bodyProfile;
late String level;
late String frequency;
late Set<String> focus;
late Set<String> limitations;
final List<String> focusOptions = const [
"Desenvolvimento equilibrado", "Glúteos", "Pernas", "Peito", "Costas", "Ombros", "Braços", "Abdômen"
];
final List<String> limitationOptions = const ["Nenhuma", "Joelho", "Ombro", "Lombar", "Outra"];
@override
void initState() {
super.initState();
final state = AppState.instance;
bodyProfile = state.bodyProfile;
level = state.trainingLevel;
frequency = state.trainingFrequency;
focus = {...state.muscleFocus};
limitations = {...state.limitations};
}
void _save() {
final state = AppState.instance;
state.bodyProfile = bodyProfile;
state.trainingLevel = level;
state.trainingFrequency = frequency;
state.muscleFocus
..clear()
..addAll(focus.isEmpty ? {"Desenvolvimento equilibrado"} : focus);
state.limitations
..clear()
..addAll(limitations.isEmpty ? {"Nenhuma"} : limitations);
state.notifyListeners();
final destination = widget.isFirstSetup
? const ReadinessCheckInScreen()
: const MainShellNav();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => destination));
}
Widget _sectionTitle(String title, String subtitle) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
]),
);
}
Widget _chip(String label, bool selected, VoidCallback onTap) {
return FilterChip(
label: Text(label),
selected: selected,
onSelected: (_) => onTap(),
selectedColor: AppColors.primaryNeon,
checkmarkColor: Colors.black,
labelStyle: TextStyle(color: selected ? Colors.black : Colors.white, fontWeight: FontWeight.w600),
backgroundColor: AppColors.cardBackground,
side: BorderSide(color: selected ? AppColors.primaryNeon : AppColors.border),
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Personalize seu treino")),
body: SafeArea(
child: ListView(
padding: const EdgeInsets.all(20),
children: [
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.primaryNeon),
),
child: const Row(children: [
Icon(Icons.auto_awesome, color: AppColors.primaryNeon, size: 28),
SizedBox(width: 12),
Expanded(child: Text(
"O FITVYA combina seu objetivo, experiência, frequência e regiões prioritárias. O perfil corporal é apenas mais um dado
nunca define o treino sozinho.",
style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
)),
]),
FITVYA PRO • main.dart atualizado • Página 18
),
const SizedBox(height: 24),
_sectionTitle("Perfil corporal (opcional)", "Usado apenas como contexto para recomendações."),
Wrap(spacing: 8, runSpacing: 8, children: [
_chip("Masculino", bodyProfile == "Masculino", () => setState(() => bodyProfile = "Masculino")),
_chip("Feminino", bodyProfile == "Feminino", () => setState(() => bodyProfile = "Feminino")),
_chip("Prefiro não informar", bodyProfile == "Prefiro não informar", () => setState(() => bodyProfile = "Prefiro não informa
]),
const SizedBox(height: 24),
_sectionTitle("Nível de treino", "Define volume e complexidade iniciais."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in const ["Iniciante", "Intermediário", "Avançado"])
_chip(item, level == item, () => setState(() => level = item)),
]),
const SizedBox(height: 24),
_sectionTitle("Frequência semanal", "Quantos dias você pretende treinar?"),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in const ["2x por semana", "3x por semana", "4x por semana", "5x por semana", "6x por semana"])
_chip(item, frequency == item, () => setState(() => frequency = item)),
]),
const SizedBox(height: 24),
_sectionTitle("O que você quer desenvolver?", "Escolha uma ou mais regiões prioritárias."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in focusOptions)
_chip(item, focus.contains(item), () {
setState(() {
if (item == "Desenvolvimento equilibrado") {
focus = {item};
} else {
focus.remove("Desenvolvimento equilibrado");
if (focus.contains(item)) {
focus.remove(item);
} else {
focus.add(item);
}
if (focus.isEmpty) focus.add("Desenvolvimento equilibrado");
}
});
}),
]),
const SizedBox(height: 24),
_sectionTitle("Limitações ou cuidados", "Ajuda o FITVYA a reduzir exercícios inadequados no futuro."),
Wrap(spacing: 8, runSpacing: 8, children: [
for (final item in limitationOptions)
_chip(item, limitations.contains(item), () {
setState(() {
if (item == "Nenhuma") {
limitations = {item};
} else {
limitations.remove("Nenhuma");
if (limitations.contains(item)) {
limitations.remove(item);
} else {
limitations.add(item);
}
if (limitations.isEmpty) limitations.add("Nenhuma");
}
});
}),
]),
const SizedBox(height: 26),
Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14)),
child: Text(
"Exemplo: com foco em Glúteos + Pernas, o FITVYA aumenta a prioridade desses movimentos; com Peito + Costas, prioriza o tr
perfil Masculino/Feminino apenas ajuda a contextualizar essa recomendação.",
style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
),
const SizedBox(height: 18),
ElevatedButton.icon(
onPressed: _save,
icon: const Icon(Icons.auto_awesome),
label: const Text("SALVAR E MONTAR MEU TREINO", style: TextStyle(fontWeight: FontWeight.bold)),
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
minimumSize: const Size.fromHeight(54),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
),
const SizedBox(height: 10),
if (!widget.isFirstSetup)
OutlinedButton(
onPressed: () => Navigator.pop(context),
child: const Text("CANCELAR"),
),
],
),
),
);
}
FITVYA PRO • main.dart atualizado • Página 19
}
class ReadinessCheckInScreen extends StatefulWidget {
const ReadinessCheckInScreen({super.key});
@override
State<ReadinessCheckInScreen> createState() => _ReadinessCheckInScreenState();
}
class _ReadinessCheckInScreenState extends State<ReadinessCheckInScreen> {
double energy = AppState.instance.energy;
double sleep = AppState.instance.sleep;
double soreness = AppState.instance.soreness;
double disposition = AppState.instance.disposition;
Widget _buildSlider({required String title, required String description, required double value, required IconData icon, required
ValueChanged<double> onChanged}) {
return Container(
margin: const EdgeInsets.only(bottom: 16),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.border),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(icon, color: AppColors.primaryNeon, size: 20),
const SizedBox(width: 8),
Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const Spacer(),
Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
decoration: BoxDecoration(color: AppColors.primaryNeon.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
child: Text("${value.toInt()}/10", style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
),
],
),
const SizedBox(height: 4),
Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
Slider(
value: value,
min: 1,
max: 10,
divisions: 9,
activeColor: AppColors.primaryNeon,
inactiveColor: Colors.grey.shade800,
onChanged: onChanged,
),
],
),
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Check-in (Prontidão)"), centerTitle: true),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Text("Como você está hoje?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
const SizedBox(height: 6),
const Text("O FITVYA ajustará a intensidade do seu treino com base no seu estado biológico atual.", style: TextStyle(color:
AppColors.textSecondary, fontSize: 14)),
const SizedBox(height: 20),
_buildSlider(title: "Nível de Energia", description: "Sentimento de disposição física geral.", value: energy, icon: Icons.bolt
onChanged: (v) => setState(() => energy = v)),
_buildSlider(title: "Qualidade do Sono", description: "Como foi sua recuperação esta noite?", value: sleep, icon: Icons.bedtim
onChanged: (v) => setState(() => sleep = v)),
_buildSlider(title: "Dor Muscular (DOMS)", description: "Quanto maior a dor, menor será a carga sugerida.", value: soreness, i
Icons.fitness_center, onChanged: (v) => setState(() => soreness = v)),
_buildSlider(title: "Disposição Mental", description: "Foco e motivação para treinar hoje.", value: disposition, icon:
Icons.psychology, onChanged: (v) => setState(() => disposition = v)),
const SizedBox(height: 12),
ElevatedButton(
onPressed: () {
// Calcula a prontidão localmente e abre imediatamente o resultado.
// O registro no Supabase/AttendanceService será integrado em uma etapa separada,
// evitando que uma falha do backend impeça o botão de funcionar.
AppState.instance.calculateReadiness(
newEnergy: energy,
newSleep: sleep,
newSoreness: soreness,
newDisposition: disposition,
);
if (!mounted) return;
FITVYA PRO • main.dart atualizado • Página 20
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const ReadinessResultScreen(),
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
minimumSize: const Size.fromHeight(54),
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
"CALCULAR PRONTIDÃO",
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
),
const SizedBox(height: 10),
OutlinedButton.icon(
onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellNav(forceNormalWorkout:
true))),
icon: const Icon(Icons.fast_forward),
label: const Text("PULAR PERSONALIZAÇÃO • TREINO NORMAL"),
),
],
),
),
);
}
}
class ReadinessResultScreen extends StatelessWidget {
const ReadinessResultScreen({super.key});
@override
Widget build(BuildContext context) {
final state = AppState.instance;
final pct = (state.readinessScore * 100).toInt();
final bool isGood = state.readinessScore >= 0.60;
return Scaffold(
appBar: AppBar(title: const Text("Resultado & Recomendação")),
body: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(20),
border: Border.all(color: isGood ? AppColors.primaryNeon : AppColors.warning),
),
child: Column(
children: [
Stack(
alignment: Alignment.center,
children: [
SizedBox(
width: 140,
height: 140,
child: CircularProgressIndicator(value: state.readinessScore, strokeWidth: 12, backgroundColor: Colors.grey.shade8
color: isGood ? AppColors.primaryNeon : AppColors.warning),
),
Column(
children: [
Text("$pct%", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
Text(isGood ? "BOA PRONTIDÃO" : "MODO LEVE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:
? AppColors.primaryNeon : AppColors.warning)),
],
)
],
),
const SizedBox(height: 20),
Text(
isGood ? "Seu corpo está pronto para um treino de ALTA/MODERADA intensidade hoje!" : "Sua recuperação foi parcial.
Recomendamos o MODO LEVE para evitar lesões.",
textAlign: TextAlign.center,
style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
),
],
),
),
const SizedBox(height: 24),
Text("Treino Sugerido • ${AppState.instance.muscleFocus.join(" + ")}", style: const TextStyle(fontSize: 18, fontWeight:
FontWeight.bold)),
FITVYA PRO • main.dart atualizado • Página 21
const SizedBox(height: 12),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color
AppColors.border)),
child: Row(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(color: AppColors.primaryNeon.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12
child: const Icon(Icons.fitness_center, color: AppColors.primaryNeon),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
AppState.instance.muscleFocus.contains("Glúteos") || AppState.instance.muscleFocus.contains("Pernas")
? "Treino prioritário de Inferiores"
: AppState.instance.muscleFocus.contains("Peito") || AppState.instance.muscleFocus.contains("Costas")
? "Treino prioritário de Superiores"
: "Treino equilibrado FITVYA",
style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
const SizedBox(height: 4),
Text(isGood ? "6 exercícios • Carga normal • 60s descanso" : "4 exercícios • Carga moderada • 90s descanso", style
TextStyle(color: AppColors.textSecondary, fontSize: 12)),
],
),
),
],
),
),
const Spacer(),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, padding: const
EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
onPressed: () {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellNav()));
},
child: const Text("IR PARA MEUS TREINOS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
),
const SizedBox(height: 10),
OutlinedButton.icon(
onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellNav(forceNormalWorkout:
true))),
icon: const Icon(Icons.fast_forward),
label: const Text("NÃO PERSONALIZAR • FAZER TREINO NORMAL"),
),
],
),
),
);
}
}
// ----------------------------------------------------------------------------
// AQUI ESTÁ A MUDANÇA NA NAVEGAÇÃO: EXCLUSÃO DA ABA "ADAPTADO"
// ----------------------------------------------------------------------------
class MainShellNav extends StatefulWidget {
final bool forceNormalWorkout;
const MainShellNav({super.key, this.forceNormalWorkout = false});
@override
State<MainShellNav> createState() => _MainShellNavState();
}
class _MainShellNavState extends State<MainShellNav> {
int _currentIndex = 0;
List<Widget> get _screens => [
MyWorkoutsScreen(forceNormalWorkout: widget.forceNormalWorkout),
const ProgressScreen(),
const GroupClassesScreen(),
const ProfileScreen(),
];
@override
Widget build(BuildContext context) {
return Scaffold(
body: IndexedStack(
index: _currentIndex,
children: _screens,
),
bottomNavigationBar: BottomNavigationBar(
currentIndex: _currentIndex,
selectedItemColor: AppColors.primaryNeon,
unselectedItemColor: Colors.grey,
backgroundColor: AppColors.cardBackground,
type: BottomNavigationBarType.fixed,
onTap: (idx) => setState(() => _currentIndex = idx),
items: const [
BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Treinos"),
FITVYA PRO • main.dart atualizado • Página 22
BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Progresso"),
BottomNavigationBarItem(icon: Icon(Icons.event_available), label: "Aulas"),
BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
],
),
);
}
}
class MyWorkoutsScreen extends StatelessWidget {
final bool forceNormalWorkout;
const MyWorkoutsScreen({super.key, this.forceNormalWorkout = false});
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Meus Treinos"),
actions: [
IconButton(
icon: const Tooltip(
message: "Histórico de treinos",
waitDuration: Duration(milliseconds: 400),
child: Icon(Icons.history, color: AppColors.primaryNeon),
),
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen())),
)
],
),
body: ListView(
padding: const EdgeInsets.all(16),
children: [
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
leading: Icon(forceNormalWorkout ? Icons.fast_forward : Icons.bolt, color: AppColors.primaryNeon, size: 32),
title: Text(forceNormalWorkout ? "Modo normal ativado" : "Prontidão Diária: ${(AppState.instance.readinessScore * 100).toInt()
subtitle: Text(forceNormalWorkout ? "A personalização foi pulada para este treino." : "Clique para recalcular sua prontidão fí
trailing: const Icon(Icons.arrow_forward_ios, size: 16),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadinessCheckInScreen())),
),
const SizedBox(height: 10),
OutlinedButton.icon(
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalizationScreen())),
icon: const Icon(Icons.auto_awesome),
label: const Text("PERSONALIZAR MEU TREINO"),
),
const SizedBox(height: 12),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.primaryNeon),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("TREINO DE HOJE", style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 12)),
const SizedBox(height: 6),
const Text("Iniciar Treino do Dia", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
const Text("Visualize os exercícios, registre cargas e repetições e acompanhe cada série em tempo real.", style: TextStyle
AppColors.textSecondary, fontSize: 12)),
const SizedBox(height: 12),
SizedBox(
width: double.infinity,
height: 52,
child: ElevatedButton.icon(
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutSheetScreen(useNormalMode:
forceNormalWorkout))),
icon: const Icon(Icons.play_arrow),
label: const Text("INICIAR TREINO DO DIA", style: TextStyle(fontWeight: FontWeight.bold)),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black),
),
), const SizedBox(height: 8),
SizedBox(
width: double.infinity,
height: 46,
child: OutlinedButton.icon(
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutSheetScreen(useNormalMode: tru
icon: const Icon(Icons.skip_next),
label: const Text("PULAR PERSONALIZAÇÃO • MODO NORMAL"),
),
),
],
),
),
const SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text("Rotinas de Treino", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
FITVYA PRO • main.dart atualizado • Página 23
TextButton.icon(
onPressed: () {},
icon: const Icon(Icons.add, color: AppColors.primaryNeon),
label: const Text("Novo Treino+", style: TextStyle(color: AppColors.primaryNeon)),
)
],
),
const SizedBox(height: 12),
_buildWorkoutCard(context, title: "Treino A: Peito + Tríceps", count: 6, duration: "60 min", isRecommended: true),
_buildWorkoutCard(context, title: "Treino B: Costas + Bíceps", count: 7, duration: "65 min", isRecommended: false),
_buildWorkoutCard(context, title: "Treino C: Pernas Completo", count: 8, duration: "70 min", isRecommended: false),
],
),
);
}
Widget _buildWorkoutCard(BuildContext context, {required String title, required int count, required String duration, required bool
isRecommended}) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: isRecommended ? AppColors.primaryNeon : AppColors.border),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (isRecommended)
Container(
margin: const EdgeInsets.only(bottom: 8),
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
decoration: BoxDecoration(color: AppColors.primaryNeon, borderRadius: BorderRadius.circular(6)),
child: const Text("RECOMENDADO PARA HOJE", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))
),
Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text("$count exercícios • $duration", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
const SizedBox(height: 16),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, shape:
RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutSheetScreen())),
child: const Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text("INICIAR TREINO", style: TextStyle(fontWeight: FontWeight.bold)),
SizedBox(width: 8),
Icon(Icons.play_arrow, size: 18),
],
),
)
],
),
);
}
}
class ActiveWorkoutScreen extends StatefulWidget {
const ActiveWorkoutScreen({super.key});
@override
State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}
class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
int currentExerciseIdx = 0;
int currentSet = 1;
bool isResting = false;
int restRemaining = 60;
Timer? _timer;
final Map<String, TextEditingController> _weightControllers = {};
final Map<String, TextEditingController> _repControllers = {};
@override
void initState() {
super.initState();
for (final ex in AppState.instance.workoutForSelectedGym) {
_weightControllers[ex.id] = TextEditingController(text: ex.defaultWeight.replaceAll(RegExp(r'[^0-9.]'), ''));
_repControllers[ex.id] = TextEditingController(text: '10');
}
}
@override
void dispose() {
_timer?.cancel();
for (final c in _weightControllers.values) c.dispose();
for (final c in _repControllers.values) c.dispose();
super.dispose();
}
void _startRest() {
FITVYA PRO • main.dart atualizado • Página 24
final ex = AppState.instance.workoutForSelectedGym[currentExerciseIdx];
restRemaining = int.tryParse(ex.restSeconds.replaceAll(RegExp(r'[^0-9]'), '')) ?? 60;
_timer?.cancel();
setState(() => isResting = true);
_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
if (!mounted) return;
if (restRemaining <= 1) {
timer.cancel();
HapticFeedback.heavyImpact();
setState(() {
restRemaining = 0;
isResting = false;
});
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
content: Text("Descanso finalizado • Próxima série liberada"),
duration: Duration(seconds: 2),
));
} else {
setState(() => restRemaining--);
}
});
}
void _changeRest(int seconds) {
setState(() {
restRemaining = (restRemaining + seconds).clamp(5, 300);
});
}
void _finishSet() {
HapticFeedback.mediumImpact();
_startRest();
if (currentSet < 4) {
setState(() => currentSet++);
}
}
Future<void> _confirmFinishWorkout() async {
_timer?.cancel();
final confirm = await showDialog<bool>(
context: context,
builder: (context) => AlertDialog(
title: const Text("Concluir treino?"),
content: const Text("Tem certeza que deseja concluir o treino agora? Seu progresso será finalizado e você verá o resumo."),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text("CONTINUAR TREINANDO"),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
),
onPressed: () => Navigator.pop(context, true),
child: const Text("CONCLUIR TREINO"),
),
],
),
);
if (confirm == true && mounted) {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const WorkoutFinishedScreen()),
);
}
}
@override
Widget build(BuildContext context) {
final exercises = AppState.instance.workoutForSelectedGym;
final currentEx = exercises[currentExerciseIdx];
final weightController = _weightControllers[currentEx.id]!;
final repController = _repControllers[currentEx.id]!;
return Scaffold(
appBar: AppBar(
title: Text("Exercício ${currentExerciseIdx + 1} de ${exercises.length}"),
actions: [
IconButton(
tooltip: "Finalizar treino",
icon: const Icon(Icons.check_circle, color: AppColors.primaryNeon, size: 28),
onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WorkoutFinishedScreen())),
)
],
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
// Alteração de ordem caso o equipamento esteja ocupado.
FITVYA PRO • main.dart atualizado • Página 25
Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(14),
border: Border.all(color: AppColors.border),
),
child: Row(
children: [
const Icon(Icons.swap_vert, color: AppColors.primaryNeon),
const SizedBox(width: 10),
const Expanded(child: Text(
"Equipamento ocupado? Você pode trocar a ordem do exercício.",
style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
)),
TextButton(
onPressed: exercises.length > 1 ? () {
setState(() {
final next = (currentExerciseIdx + 1) % exercises.length;
final tmp = exercises[currentExerciseIdx];
exercises[currentExerciseIdx] = exercises[next];
exercises[next] = tmp;
});
} : null,
child: const Text("TROCAR"),
)
],
),
),
const SizedBox(height: 12),
InkWell(
borderRadius: BorderRadius.circular(16),
onTap: () => Navigator.push(context, MaterialPageRoute(
builder: (_) => ExerciseDetailScreen(exercise: currentEx),
)),
child: Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.border),
),
child: Column(
children: [
const Icon(Icons.play_circle_outline, size: 58, color: AppColors.primaryNeon),
const SizedBox(height: 8),
Text(currentEx.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
Text("Aparelho: ${currentEx.targetEquipment}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
const SizedBox(height: 6),
Builder(
builder: (context) {
final available = AppState.instance.hasEquipmentForSelectedGym(currentEx.targetEquipment);
return Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(available ? Icons.check_circle : Icons.warning_amber_rounded, size: 15, color: available ? AppColors.succ
AppColors.warning),
const SizedBox(width: 5),
Text(
available ? "Disponível na ${AppState.instance.selectedGym}" : "Não disponível nesta academia • use:
${currentEx.fallbackExercise}",
style: TextStyle(color: available ? AppColors.success : AppColors.warning, fontSize: 11, fontWeight:
FontWeight.w600),
textAlign: TextAlign.center,
),
],
);
},
),
const SizedBox(height: 8),
const Text("Toque para ver instruções e demonstração", style: TextStyle(color: AppColors.primaryNeon, fontSize: 12)),
],
),
),
),
const SizedBox(height: 16),
Row(
children: [
Expanded(child: _buildStatTile("Série", "$currentSet de 4")),
const SizedBox(width: 8),
Expanded(child: _buildInputTile("Repetições", repController)),
const SizedBox(width: 8),
Expanded(child: _buildInputTile("Carga (kg)", weightController)),
],
),
const SizedBox(height: 16),
if (isResting)
Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: AppColors.primaryNeon.withValues(alpha: 0.10),
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.primaryNeon),
FITVYA PRO • main.dart atualizado • Página 26
),
child: Column(
children: [
const Text("DESCANSO", style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
const SizedBox(height: 6),
Text("${restRemaining ~/ 60}:${(restRemaining % 60).toString().padLeft(2, '0')}",
style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
Row(
children: [
Expanded(child: OutlinedButton(
onPressed: () => _changeRest(-15),
child: const Text("-15s"),
)),
const SizedBox(width: 8),
Expanded(child: OutlinedButton(
onPressed: () => _changeRest(30),
child: const Text("+30s"),
)),
const SizedBox(width: 8),
Expanded(child: ElevatedButton(
onPressed: () {
_timer?.cancel();
setState(() => isResting = false);
},
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black),
child: const Text("PULAR"),
)),
],
),
],
),
)
else
Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
child: Row(
children: [
const Icon(Icons.timer_outlined, color: AppColors.primaryNeon),
const SizedBox(width: 10),
const Expanded(child: Text("Descanso sugerido", style: TextStyle(color: AppColors.textSecondary))),
Text(currentEx.restSeconds, style: const TextStyle(fontWeight: FontWeight.bold)),
],
),
),
const SizedBox(height: 20),
SizedBox(
height: 58,
child: ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
onPressed: isResting ? null : _finishSet,
icon: const Icon(Icons.check_circle_outline),
label: Text("CONCLUIR SÉRIE ${currentSet}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
),
),
const SizedBox(height: 10),
if (currentExerciseIdx < exercises.length - 1)
SizedBox(
height: 54,
child: OutlinedButton.icon(
onPressed: () {
setState(() {
currentExerciseIdx++;
currentSet = 1;
});
},
icon: const Icon(Icons.arrow_forward),
label: const Text("PRÓXIMO EXERCÍCIO", style: TextStyle(fontWeight: FontWeight.bold)),
),
),
if (currentExerciseIdx < exercises.length - 1) const SizedBox(height: 12),
SizedBox(
height: 60,
child: ElevatedButton.icon(
onPressed: _confirmFinishWorkout,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.redAccent,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
icon: const Icon(Icons.flag_circle),
label: const Text(
"CONCLUIR TREINO",
style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
),
),
),
const SizedBox(height: 8),
const Text(
FITVYA PRO • main.dart atualizado • Página 27
"Seus dados de carga e repetições ficam visíveis antes da próxima série para reduzir digitação durante o treino.",
textAlign: TextAlign.center,
style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
),
],
),
),
);
}
Widget _buildStatTile(String label, String value) {
return Container(
padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color:
AppColors.border)),
child: Column(children: [
Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
const SizedBox(height: 4),
Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
]),
);
}
Widget _buildInputTile(String label, TextEditingController controller) {
return Container(
padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color:
AppColors.border)),
child: Column(children: [
Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
SizedBox(
height: 36,
child: TextField(
controller: controller,
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
style: const TextStyle(fontWeight: FontWeight.bold),
decoration: const InputDecoration(border: InputBorder.none, isDense: true),
),
),
]),
);
}
}
class WorkoutFinishedScreen extends StatelessWidget {
const WorkoutFinishedScreen({super.key});
@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Icon(Icons.check_circle_outline, size: 96, color: AppColors.primaryNeon),
const SizedBox(height: 16),
const Text("Treino Concluído!", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
const SizedBox(height: 32),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black, padding: const
EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellNav())),
child: const Text("FINALIZAR E VOLTAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
),
],
),
),
),
);
}
}
class WorkoutHistoryScreen extends StatelessWidget {
const WorkoutHistoryScreen({super.key});
@override
Widget build(BuildContext context) {
final history = AppState.instance.workoutHistory;
return Scaffold(
appBar: AppBar(title: const Text("Histórico de Treinos")),
body: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: history.length,
itemBuilder: (context, index) {
final item = history[index];
return Card(
color: AppColors.cardBackground,
margin: const EdgeInsets.only(bottom: 12),
child: ListTile(
FITVYA PRO • main.dart atualizado • Página 28
leading: Text(item.ratingEmoji, style: const TextStyle(fontSize: 28)),
title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
subtitle: Text("${item.date} • ${item.duration}"),
trailing: Text(item.totalVolumeKg, style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
),
);
},
),
);
}
}
class WorkoutSheetScreen extends StatefulWidget {
final bool useNormalMode;
const WorkoutSheetScreen({super.key, this.useNormalMode = false});
@override
State<WorkoutSheetScreen> createState() => _WorkoutSheetScreenState();
}
class _WorkoutSheetScreenState extends State<WorkoutSheetScreen> {
List<bool> exerciciosConcluidos = [];
@override
void initState() {
super.initState();
final exercicios = widget.useNormalMode
? AppState.instance.normalWorkout
: AppState.instance.workoutForSelectedGym;
exerciciosConcluidos = List.generate(
exercicios.length,
(index) => false,
);
}
@override
Widget build(BuildContext context) {
final exercicios = widget.useNormalMode
? AppState.instance.normalWorkout
: AppState.instance.workoutForSelectedGym;
return Scaffold(
appBar: AppBar(title: const Text("Detalhes do Treino")),
body: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
widget.useNormalMode
? "Lista de Exercícios • Modo Normal"
: "Lista de Exercícios Adaptados",
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 16),
Expanded(
child: ListView.builder(
itemCount: exercicios.length,
itemBuilder: (context, index) {
final ex = exercicios[index];
return Card(
color: AppColors.cardBackground,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: const BorderSide(color: AppColors.border),
),
child: Padding(
padding: const EdgeInsets.all(12.0),
child: Row(
children: [
Container(
width: 60,
height: 60,
decoration: BoxDecoration(
color: AppColors.background,
borderRadius: BorderRadius.circular(8),
),
child: const Icon(Icons.fitness_center, color: AppColors.primaryNeon, size: 30),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
ex.name,
style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
),
Text(
"Aparelho: ${ex.targetEquipment}",
style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
const SizedBox(height: 8),
FITVYA PRO • main.dart atualizado • Página 29
Row(
children: [
const Icon(Icons.repeat, size: 14, color: AppColors.primaryNeon),
const SizedBox(width: 4),
Text(ex.normalSets, style: const TextStyle(color: Colors.white, fontSize: 12)),
const SizedBox(width: 12),
const Icon(Icons.timer, size: 14, color: AppColors.warning),
const SizedBox(width: 4),
Text(ex.restSeconds, style: const TextStyle(color: Colors.white, fontSize: 12)),
],
),
],
),
),
Column(
children: [
SizedBox(
width: 55,
height: 35,
child: TextField(
controller: TextEditingController(text: ex.defaultWeight),
keyboardType: TextInputType.number,
style: const TextStyle(color: Colors.white, fontSize: 12),
textAlign: TextAlign.center,
decoration: InputDecoration(
contentPadding: EdgeInsets.zero,
filled: true,
fillColor: AppColors.background,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(6),
borderSide: BorderSide.none,
),
),
),
),
const SizedBox(height: 4),
SizedBox(
height: 24,
width: 24,
child: Checkbox(
value: exerciciosConcluidos[index],
onChanged: (bool? value) {
setState(() {
exerciciosConcluidos[index] = value ?? false;
});
},
activeColor: AppColors.primaryNeon,
checkColor: Colors.black,
),
),
],
)
],
),
),
);
},
),
),
const SizedBox(height: 16),
AnimatedBuilder(
animation: AppState.instance,
builder: (context, _) {
final todosConcluidos =
exerciciosConcluidos.isNotEmpty &&
exerciciosConcluidos.every((concluido) => concluido);
return Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
if (todosConcluidos)
SizedBox(
height: 58,
child: ElevatedButton.icon(
onPressed: () {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const WorkoutFinishedScreen(),
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
icon: const Icon(Icons.check_circle),
label: const Text(
"CONCLUIR TREINO",
style: TextStyle(
FITVYA PRO • main.dart atualizado • Página 30
fontSize: 16,
fontWeight: FontWeight.w900,
),
),
),
)
else
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: AppColors.border),
),
child: const Row(
children: [
Icon(
Icons.info_outline,
color: AppColors.textSecondary,
),
SizedBox(width: 8),
Expanded(
child: Text(
"Marque todos os exercícios como concluídos para finalizar o treino.",
style: TextStyle(
color: AppColors.textSecondary,
fontSize: 12,
),
),
),
],
),
),
],
);
},
),
],
),
),
);
}
}
class ExerciseDetailScreen extends StatelessWidget {
final ExerciseModel exercise;
const ExerciseDetailScreen({super.key, required this.exercise});
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text(exercise.name)),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 8),
Text(exercise.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
const SizedBox(height: 6),
Text("Músculos alvo • ${exercise.targetEquipment}", style: const TextStyle(color: AppColors.textSecondary)),
const SizedBox(height: 6),
const SizedBox(height: 18),
const Text("Como executar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
const Text(
"1. Ajuste o aparelho e mantenha a postura indicada.\n"
"2. Execute o movimento de forma controlada, respeitando sua amplitude.\n"
"3. Retorne lentamente à posição inicial e mantenha a respiração regular.",
style: TextStyle(color: AppColors.textSecondary, height: 1.5),
),
const SizedBox(height: 18),
Row(
children: [
Expanded(child: _info("Séries", exercise.normalSets)),
const SizedBox(width: 10),
Expanded(child: _info("Descanso", exercise.restSeconds)),
],
),
const SizedBox(height: 18),
const SizedBox(height: 18),
OutlinedButton.icon(
onPressed: () => _showFallback(context),
icon: const Icon(Icons.swap_horiz),
label: Text("EQUIPAMENTO ALTERNATIVO: ${exercise.fallbackExercise}"),
),
],
),
),
);
}
Widget _info(String title, String value) {
FITVYA PRO • main.dart atualizado • Página 31
return Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color:
AppColors.border)),
child: Column(children: [
Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
const SizedBox(height: 5),
Text(value, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
]),
);
}
void _showFallback(BuildContext context) {
showDialog(
context: context,
builder: (_) => AlertDialog(
title: const Text("Alternativa"),
content: Text("Se ${exercise.targetEquipment} estiver ocupado, utilize: ${exercise.fallbackExercise}."),
actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
),
);
}
}
class GestorPlanScreen extends StatefulWidget {
const GestorPlanScreen({super.key});
@override
State<GestorPlanScreen> createState() => _GestorPlanScreenState();
}
class _GestorPlanScreenState extends State<GestorPlanScreen> {
bool annual = false;
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Plano da Academia")),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
const FitVyaLogo(height: 115),
const SizedBox(height: 8),
Text("Versão atual: ${state.gestorPlan}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight:
FontWeight.bold)),
const SizedBox(height: 20),
_versionCard(
title: "PILOTO",
price: "R\$ 0",
description: "Versão de demonstração para validar o fluxo do gestor, academia, equipamentos e alunos.",
active: state.gestorPlan == "Piloto",
),
const SizedBox(height: 12),
_versionCard(
title: "FINAL • FITVYA PRO",
price: annual ? "R\$ 999,90/ano" : "R\$ 99,99/mês",
description: "Plano por academia com gestão completa. No anual, o valor é equivalente a R\$ 83,33/mês.",
active: state.gestorPlan == "Final",
),
const SizedBox(height: 16),
SwitchListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
title: const Text("Cobrança anual"),
subtitle: Text(annual ? "R\$ 999,90 por ano" : "R\$ 99,99 por mês"),
value: annual,
activeColor: AppColors.primaryNeon,
onChanged: (v) => setState(() => annual = v),
),
const SizedBox(height: 16),
SizedBox(
height: 54,
child: ElevatedButton.icon(
onPressed: () {
state.activateGestorPlan(annual: annual);
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Plano ${annual ? 'anual' : 'mensal'} ativado em modo demonstração.")),
);
setState(() {});
},
icon: const Icon(Icons.credit_card),
label: Text(state.gestorPlanActive ? "ATUALIZAR ASSINATURA" : "ATIVAR PLANO FINAL"),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black),
),
),
const SizedBox(height: 10),
if (state.gestorPlanActive)
OutlinedButton(
onPressed: () {
state.returnToPilotPlan();
setState(() {});
FITVYA PRO • main.dart atualizado • Página 32
},
child: const Text("VOLTAR PARA O PILOTO"),
),
const SizedBox(height: 18),
const Text(
"Observação: esta tela implementa a lógica e a interface de planos para o piloto. A cobrança real (Stripe, Mercado Pago ou out
gateway) deve ser conectada no backend antes do lançamento comercial.",
style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
),
],
),
);
}
Widget _versionCard({required String title, required String price, required String description, required bool active}) {
return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: active ? AppColors.primaryNeon : AppColors.border, width: active ? 1.5 : 1),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Expanded(child: Text(title, style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 14))
if (active) const Icon(Icons.check_circle, color: AppColors.primaryNeon),
],
),
const SizedBox(height: 8),
Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
const SizedBox(height: 8),
Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.45)),
],
),
);
}
}
class TutorialScreen extends StatefulWidget {
const TutorialScreen({super.key});
@override
State<TutorialScreen> createState() => _TutorialScreenState();
}
class _TutorialScreenState extends State<TutorialScreen> {
final PageController _controller = PageController();
int page = 0;
final steps = const [
("1. Escolha seu perfil", "Entre como Aluno para treinar ou Gestor de Academia para administrar a unidade."),
("2. Faça o check-in", "O FITVYA pergunta energia, sono, dor muscular e disposição para calcular a prontidão."),
("3. Personalize ou pule", "Você pode seguir a recomendação do FITVYA ou tocar em “Pular personalização” e fazer o treino normal."),
("4. Veja o exercício", "Toque em qualquer exercício para abrir as instruções, séries, descanso e alternativa de equipamento. O GIF
licenciado será inserido futuramente neste mesmo local."),
("5. Procure sua academia", "Use a busca para localizar a academia e conferir os equipamentos disponíveis."),
("6. Gestor: cadastre a unidade", "O gestor acompanha alunos, equipamentos, manutenção e dados da academia."),
("7. Gestor: escolha o plano", "O piloto é gratuito para demonstração. A versão final prevê R\$ 99,99/mês por academia ou opção anual.
("8. Pronto", "O tutorial é opcional e pode ser reaberto pelo Perfil a qualquer momento."),
];
@override
void dispose() {
_controller.dispose();
super.dispose();
}
@override
Widget build(BuildContext context) {
final isLast = page == steps.length - 1;
return Scaffold(
appBar: AppBar(title: const Text("Tutorial FITVYA")),
body: Column(
children: [
Expanded(
child: PageView.builder(
controller: _controller,
itemCount: steps.length,
onPageChanged: (v) => setState(() => page = v),
itemBuilder: (_, i) {
final item = steps[i];
return Padding(
padding: const EdgeInsets.all(28),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const FitVyaLogo(height: 120),
const SizedBox(height: 28),
CircleAvatar(
radius: 38,
FITVYA PRO • main.dart atualizado • Página 33
backgroundColor: AppColors.primaryNeon,
child: Text("${i + 1}", style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900)),
),
const SizedBox(height: 24),
Text(item.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
const SizedBox(height: 14),
Text(item.$2, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, height: 1.6)),
],
),
);
},
),
),
Padding(
padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
child: Row(
children: [
TextButton(onPressed: () => Navigator.pop(context), child: const Text("PULAR")),
const Spacer(),
ElevatedButton(
onPressed: () {
if (isLast) {
Navigator.pop(context);
} else {
_controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
}
},
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon, foregroundColor: Colors.black),
child: Text(isLast ? "CONCLUIR" : "PRÓXIMO"),
),
],
),
),
],
),
);
}
}
class GroupClassesScreen extends StatefulWidget {
const GroupClassesScreen({super.key});
@override
State<GroupClassesScreen> createState() => _GroupClassesScreenState();
}
class _GroupClassesScreenState extends State<GroupClassesScreen> {
String selectedModality = "Todas";
String selectedDate = "Todas";
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Aulas / Agenda")),
body: ListenableBuilder(
listenable: state,
builder: (context, _) {
final modalities = ["Todas", ...state.groupClasses.map((e) => e.modality).toSet()];
final dates = ["Todas", ...state.groupClasses.map((e) => e.date).toSet()];
final list = state.groupClasses.where((aula) {
final byModality = selectedModality == "Todas" || aula.modality == selectedModality;
final byDate = selectedDate == "Todas" || aula.date == selectedDate;
return byModality && byDate;
}).toList();
return Column(
children: [
// Calendário simplificado: seleção de dia + filtros por modalidade.
SizedBox(
height: 62,
child: ListView(
scrollDirection: Axis.horizontal,
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
children: dates.map((date) {
final selected = selectedDate == date;
return Padding(
padding: const EdgeInsets.only(right: 8),
child: ChoiceChip(
label: Text(date == "Todas" ? "Todos os dias" : date),
selected: selected,
selectedColor: AppColors.primaryNeon,
labelStyle: TextStyle(color: selected ? Colors.black : Colors.white),
onSelected: (_) => setState(() => selectedDate = date),
),
);
}).toList(),
),
),
SizedBox(
height: 50,
child: ListView(
scrollDirection: Axis.horizontal,
FITVYA PRO • main.dart atualizado • Página 34
padding: const EdgeInsets.symmetric(horizontal: 16),
children: modalities.map((mod) {
final selected = selectedModality == mod;
return Padding(
padding: const EdgeInsets.only(right: 8),
child: ChoiceChip(
label: Text(mod),
selected: selected,
selectedColor: AppColors.primaryNeon,
labelStyle: TextStyle(color: selected ? Colors.black : Colors.white),
onSelected: (_) => setState(() => selectedModality = mod),
),
);
}).toList(),
),
),
Expanded(
child: list.isEmpty
? const Center(child: Text("Nenhuma aula encontrada.", style: TextStyle(color: AppColors.textSecondary)))
: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: list.length,
itemBuilder: (context, index) {
final aula = list[index];
final reserved = state.reservedClasses.contains(aula.id);
final full = aula.availableSpots <= 0 && !reserved;
final status = reserved
? "Sua vaga está reservada"
: full
? "ESGOTADO"
: aula.availableSpots <= 2
? "Últimas ${aula.availableSpots} vagas"
: "${aula.availableSpots} vagas disponíveis";
return Card(
color: AppColors.cardBackground,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color:
AppColors.border)),
child: Padding(
padding: const EdgeInsets.all(14),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(color: AppColors.primaryNeon.withValues(alpha: 0.12), borderRadius:
BorderRadius.circular(10)),
child: const Icon(Icons.groups, color: AppColors.primaryNeon),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(aula.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
Text("${aula.instructor} • ${aula.modality}", style: const TextStyle(color: AppColors.textSeco
fontSize: 12)),
],
),
),
Text(aula.time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
],
),
const SizedBox(height: 12),
Row(
children: [
const Icon(Icons.calendar_today, size: 15, color: AppColors.textSecondary),
const SizedBox(width: 5),
Text(aula.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
const SizedBox(width: 14),
Icon(Icons.circle, size: 10, color: reserved ? AppColors.primaryNeon : (full ? AppColors.danger :
(aula.availableSpots <= 2 ? AppColors.warning : AppColors.success))),
const SizedBox(width: 5),
Expanded(child: Text(status, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
],
),
const SizedBox(height: 12),
SizedBox(
height: 48,
width: double.infinity,
child: ElevatedButton(
onPressed: full
? () => _showWaitlist(context, aula, state.waitlistedClasses.contains(aula.id))
: () {
if (reserved) {
state.cancelClass(aula.id);
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reserva cancelada
} else if (state.reserveClass(aula.id)) {
HapticFeedback.mediumImpact();
_showConfirmation(context, aula);
FITVYA PRO • main.dart atualizado • Página 35
}
},
style: ElevatedButton.styleFrom(
backgroundColor: reserved ? AppColors.cardBackground : AppColors.primaryNeon,
foregroundColor: reserved ? Colors.white : Colors.black,
side: reserved ? const BorderSide(color: AppColors.primaryNeon) : null,
),
child: Text(reserved ? "CANCELAR RESERVA" : full ? "ENTRAR NA LISTA DE ESPERA" : "RESERVAR VAGA",
style: const TextStyle(fontWeight: FontWeight.bold)),
),
),
],
),
),
);
},
),
),
],
);
},
),
);
}
void _showConfirmation(BuildContext context, GroupClassModel aula) {
showDialog(
context: context,
builder: (_) => AlertDialog(
title: const Text("Vaga confirmada"),
content: Text("${aula.name} • ${aula.date} às ${aula.time}\\nInstrutor: ${aula.instructor}\\n\\nLembrete ativado para você não per
aula."),
actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
),
);
}
void _showWaitlist(BuildContext context, GroupClassModel aula, bool alreadyWaiting) {
showDialog(
context: context,
builder: (_) => AlertDialog(
title: Text(alreadyWaiting ? "Lista de espera" : "Turma lotada"),
content: Text(alreadyWaiting
? "Você já está na lista de espera de ${aula.name}. Deseja sair?"
: "A turma ${aula.name} está esgotada. Deseja entrar na lista de espera?"),
actions: [
TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
ElevatedButton(
onPressed: () {
if (alreadyWaiting) {
AppState.instance.leaveWaitlist(aula.id);
} else {
AppState.instance.joinWaitlist(aula.id);
}
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(alreadyWaiting ? "Você saiu da lista de espera." : "Você e
na lista de espera.")));
},
child: Text(alreadyWaiting ? "SAIR" : "ENTRAR"),
),
],
),
);
}
}
class ProgressScreen extends StatelessWidget {
const ProgressScreen({super.key});
@override
Widget build(BuildContext context) {
final state = AppState.instance;
final treinosConcluidos = state.workoutHistory.length;
return Scaffold(
appBar: AppBar(title: const Text("Progresso & Evolução")),
body: ListView(
padding: const EdgeInsets.all(16.0),
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
_buildMetricaCard("Ofensiva", "3 Dias", Icons.local_fire_department, AppColors.warning),
_buildMetricaCard("Treinos", "$treinosConcluidos/mês", Icons.calendar_month, AppColors.primaryNeon),
_buildMetricaCard("Tempo", "4h", Icons.timer, AppColors.success),
],
),
const SizedBox(height: 32),
const Text(
"Evolução de Cargas",
style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 16),
Container(
FITVYA PRO • main.dart atualizado • Página 36
height: 220,
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: AppColors.border),
),
alignment: Alignment.center,
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.show_chart, size: 60, color: AppColors.primaryNeon),
const SizedBox(height: 8),
const Text(
"Gráfico de Desempenho",
style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
),
Text(
"(Instale fl_chart para renderizar)",
style: TextStyle(color: Colors.grey[700], fontSize: 10),
),
],
),
),
],
),
);
}
Widget _buildMetricaCard(String titulo, String valor, IconData icone, Color cor) {
return Expanded(
child: Card(
color: AppColors.cardBackground,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: const BorderSide(color: AppColors.border),
),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
child: Column(
children: [
Icon(icone, color: cor, size: 28),
const SizedBox(height: 8),
Text(valor, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text(titulo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
],
),
),
),
);
}
}
// ----------------------------------------------------------------------------
// AQUI ESTÁ A MUDANÇA NA TELA DE ACADEMIAS: BARRA DE PESQUISA ADICIONADA
// ----------------------------------------------------------------------------
class SelectGymScreen extends StatefulWidget {
const SelectGymScreen({super.key});
@override
State<SelectGymScreen> createState() => _SelectGymScreenState();
}
class _SelectGymScreenState extends State<SelectGymScreen> {
String searchQuery = "";
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Selecionar Academia")),
body: ListenableBuilder(
listenable: state,
builder: (context, _) {
final filteredGyms = state.userGyms
.where((gym) => gym.toLowerCase().contains(searchQuery.toLowerCase()))
.toList();
return Column(
children: [
Padding(
padding: const EdgeInsets.all(16.0),
child: TextField(
onChanged: (value) {
setState(() {
searchQuery = value;
});
},
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: 'Pesquisar academia...',
hintStyle: const TextStyle(color: AppColors.textSecondary),
prefixIcon: const Tooltip(
FITVYA PRO • main.dart atualizado • Página 37
message: "Pesquisar academia",
waitDuration: Duration(milliseconds: 400),
child: Icon(Icons.search, color: AppColors.textSecondary),
),
filled: true,
fillColor: AppColors.cardBackground,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: AppColors.primaryNeon),
),
),
),
),
Expanded(
child: ListView.builder(
padding: const EdgeInsets.symmetric(horizontal: 16),
itemCount: filteredGyms.length,
itemBuilder: (context, index) {
final gym = filteredGyms[index];
final isSel = gym == state.selectedGym;
return MouseRegion(
cursor: SystemMouseCursors.click,
child: InkWell(
borderRadius: BorderRadius.circular(12),
onTap: () {
state.selectGym(gym);
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Academia alterada para $gym. O treino foi adaptado aos equipamentos disponíveis.")),
);
Navigator.pop(context);
},
child: Container(
margin: const EdgeInsets.only(bottom: 12),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: isSel ? AppColors.primaryNeon : AppColors.border,
width: 1.5,
),
),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
title: Text(
gym,
style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 6),
const Text(
"Endereço cadastrado na base",
style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
const SizedBox(height: 6),
Row(
children: [
Icon(Icons.circle, size: 10, color: index == 0 ? AppColors.success : AppColors.warning),
const SizedBox(width: 4),
Text(
index == 0 ? "Lotação Tranquila" : "Lotação Moderada",
style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
],
),
],
),
trailing: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.location_on, color: AppColors.primaryNeon, size: 20),
const SizedBox(height: 4),
Text(
"${(index + 1) * 2.5} km",
style: const TextStyle(color: AppColors.primaryNeon, fontSize: 12, fontWeight: FontWeight.bold),
),
],
),
),
),
),
);
},
),
),
],
);
FITVYA PRO • main.dart atualizado • Página 38
},
),
);
}
}
class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});
Future<void> _deleteAccount(BuildContext context) async {
final confirmed = await showDialog<bool>(
context: context,
builder: (_) => AlertDialog(
title: const Text("Excluir conta?"),
content: const Text(
"Tem certeza que quer excluir essa conta? Essa ação remove os dados da conta deste dispositivo e não pode ser desfeita.",
),
actions: [
TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCELAR")),
ElevatedButton(
onPressed: () => Navigator.pop(context, true),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
child: const Text("EXCLUIR CONTA"),
),
],
),
);
if (confirmed != true || !context.mounted) return;
final passwordController = TextEditingController();
final passwordConfirmed = await showDialog<bool>(
context: context,
builder: (_) => AlertDialog(
title: const Text("Confirme sua senha"),
content: TextField(
controller: passwordController,
obscureText: true,
autofocus: true,
decoration: const InputDecoration(
labelText: "Senha cadastrada",
prefixIcon: Icon(Icons.lock_outline),
),
),
actions: [
TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCELAR")),
ElevatedButton(
onPressed: () {
final ok = AppState.instance.deleteAccount(passwordController.text);
Navigator.pop(context, ok);
},
style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
child: const Text("CONFIRMAR EXCLUSÃO"),
),
],
),
);
passwordController.dispose();
if (!context.mounted) return;
if (passwordConfirmed == true) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Conta excluída com sucesso.")));
Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(builder: (_) => const LoginScreen()),
(_) => false,
);
} else {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Senha incorreta. A conta não foi excluída.")));
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Perfil")),
body: Padding(
padding: const EdgeInsets.all(20.0),
child: ListView(
children: [
const CircleAvatar(radius: 40, backgroundColor: AppColors.primaryNeon, child: Icon(Icons.person, size: 40, color: Colors.black
const SizedBox(height: 16),
Text(AppState.instance.userName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold
Text(AppState.instance.userEmail, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
const SizedBox(height: 30),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.fitness_center, color: AppColors.primaryNeon),
title: const Text("Academia atual"),
subtitle: Text(AppState.instance.selectedGym),
trailing: Tooltip(
message: "Trocar de academia",
FITVYA PRO • main.dart atualizado • Página 39
waitDuration: const Duration(milliseconds: 400),
child: const Icon(Icons.swap_horiz, color: AppColors.primaryNeon),
),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectGymScreen())),
),
const SizedBox(height: 12),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.school_outlined, color: AppColors.primaryNeon),
title: const Text("Tutorial do FITVYA"),
subtitle: const Text("Guia opcional de uso do aplicativo"),
trailing: const Icon(Icons.chevron_right, color: AppColors.primaryNeon),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialScreen())),
),
const SizedBox(height: 12),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.lock_outline, color: AppColors.primaryNeon),
title: const Text("Segurança da conta"),
subtitle: const Text("Senha usada para confirmar ações sensíveis"),
),
const SizedBox(height: 12),
SizedBox(
height: 52,
child: ElevatedButton(
onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
style: ElevatedButton.styleFrom(backgroundColor: AppColors.cardBackground, foregroundColor: Colors.white, side: const
BorderSide(color: AppColors.border)),
child: const Text("SAIR DA CONTA"),
),
),
const SizedBox(height: 12),
SizedBox(
height: 52,
child: OutlinedButton.icon(
onPressed: () => _deleteAccount(context),
icon: const Icon(Icons.delete_forever, color: AppColors.danger),
label: const Text("EXCLUIR CONTA", style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
),
),
],
),
),
);
}
}
// ============================================================================
// 5. FLUXO DO GESTOR (DASHBOARD, EQUIPAMENTOS, MANUTENÇÕES)
// ============================================================================
class GestorMainShellNav extends StatefulWidget {
const GestorMainShellNav({super.key});
@override
State<GestorMainShellNav> createState() => _GestorMainShellNavState();
}
class _GestorMainShellNavState extends State<GestorMainShellNav> {
int _currentIndex = 0;
final List<Widget> _tabs = [
const GestorDashboardTab(),
const GestorGymDetailsTab(),
const GestorEquipmentsTab(),
const GestorMaintenanceTab(),
const GestorProfileTab(),
];
@override
Widget build(BuildContext context) {
return Scaffold(
body: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: _tabs[_currentIndex]),
bottomNavigationBar: BottomNavigationBar(
currentIndex: _currentIndex,
onTap: (idx) => setState(() => _currentIndex = idx),
selectedItemColor: AppColors.primaryNeon,
unselectedItemColor: AppColors.textSecondary,
backgroundColor: AppColors.cardBackground,
type: BottomNavigationBarType.fixed,
items: const [
BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: "Academia"),
BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), label: "Equipamentos"),
BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: "Manutenção"),
BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Perfil"),
],
),
);
}
}
class GestorDashboardTab extends StatelessWidget {
FITVYA PRO • main.dart atualizado • Página 40
const GestorDashboardTab({super.key});
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Painel do Gestor - FITVYA")),
body: ListenableBuilder(
listenable: state,
builder: (context, _) {
return SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(c
AppColors.primaryNeon, width: 1.5)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(state.gymName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
const SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text("Alunos Ativos no Momento:", style: TextStyle(color: AppColors.textSecondary)),
Text("${state.activeStudentsCount} alunos", style: const TextStyle(color: AppColors.primaryNeon, fontWeight:
FontWeight.bold, fontSize: 16)),
],
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text("Lotação Atual:", style: TextStyle(color: AppColors.textSecondary)),
Text(state.gymCapacityText, style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSi
16)),
],
),
],
),
),
const SizedBox(height: 16),
GestureDetector(
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GestorPlanScreen())),
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.65)),
),
child: Row(
children: [
const Icon(Icons.workspace_premium, color: AppColors.primaryNeon, size: 30),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text("Plano ${state.gestorPlan}", style: const TextStyle(fontWeight: FontWeight.bold)),
Text(
state.gestorPlanActive
? "R\$ ${state.currentPlanPrice.toStringAsFixed(2).replaceAll('.', ',')} • ${state.gestorAnnualBilling
'anual' : 'mensal'}"
: "Piloto gratuito • confira a versão final",
style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
),
],
),
),
const Icon(Icons.chevron_right, color: AppColors.primaryNeon),
],
),
),
),
const SizedBox(height: 24),
const Text("Status dos Equipamentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 12),
ListView.separated(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: state.gymEquipments.length,
separatorBuilder: (_, __) => const SizedBox(height: 10),
itemBuilder: (context, index) {
final item = state.gymEquipments[index];
return Container(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border:
Border.all(color: AppColors.border)),
child: Row(
FITVYA PRO • main.dart atualizado • Página 41
children: [
CircleAvatar(
radius: 16,
backgroundColor: item.isAvailable ? AppColors.success.withValues(alpha: 0.2) : AppColors.warning.withValues(al
0.2),
child: Icon(item.isAvailable ? Icons.check_circle : Icons.build, color: item.isAvailable ? AppColors.success :
AppColors.warning, size: 18),
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
Text(item.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
],
),
),
TextButton(
onPressed: () => state.toggleEquipment(item.id),
child: Text(
item.isAvailable ? "Marcar Manutenção" : "Ativar Equipamento",
style: TextStyle(color: item.isAvailable ? AppColors.warning : AppColors.primaryNeon, fontWeight: FontWeight
fontSize: 13),
),
),
],
),
);
},
),
],
),
);
},
),
);
}
}
class GestorGymDetailsTab extends StatelessWidget {
const GestorGymDetailsTab({super.key});
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Detalhes da Academia")),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
children: [
ListTile(title: const Text("Nome da Academia"), subtitle: Text(state.gymName, style: const TextStyle(color: Colors.white, font
16)), leading: const Icon(Icons.store, color: AppColors.primaryNeon)),
const Divider(color: AppColors.border),
ListTile(title: const Text("CNPJ"), subtitle: Text(state.gymCnpj, style: const TextStyle(color: Colors.white, fontSize: 16)),
leading: const Icon(Icons.badge, color: AppColors.primaryNeon)),
const Divider(color: AppColors.border),
ListTile(title: const Text("Endereço"), subtitle: Text(state.gymAddress, style: const TextStyle(color: Colors.white, fontSize:
leading: const Icon(Icons.location_on, color: AppColors.primaryNeon)),
const Divider(color: AppColors.border),
ListTile(title: const Text("Horário de Funcionamento"), subtitle: Text(state.gymHours, style: const TextStyle(color: Colors.wh
fontSize: 16)), leading: const Icon(Icons.access_time, color: AppColors.primaryNeon)),
],
),
),
);
}
}
class GestorEquipmentsTab extends StatefulWidget {
const GestorEquipmentsTab({super.key});
@override
State<GestorEquipmentsTab> createState() => _GestorEquipmentsTabState();
}
class _GestorEquipmentsTabState extends State<GestorEquipmentsTab> {
String selectedFilter = "Todos";
String searchQuery = "";
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Equipamentos")),
floatingActionButton: FloatingActionButton(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
child: const Icon(Icons.add),
onPressed: () {},
),
body: ListenableBuilder(
FITVYA PRO • main.dart atualizado • Página 42
listenable: state,
builder: (context, _) {
final items = state.gymEquipments.where((e) {
if (selectedFilter == "Disponíveis" && !e.isAvailable) return false;
if (selectedFilter == "Manutenção" && e.isAvailable) return false;
if (searchQuery.isNotEmpty && !e.name.toLowerCase().contains(searchQuery.toLowerCase())) return false;
return true;
}).toList();
return Column(
children: [
Padding(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
child: Row(
children: ["Todos", "Disponíveis", "Manutenção"].map((f) {
final isSel = selectedFilter == f;
return Padding(
padding: const EdgeInsets.only(right: 8.0),
child: ChoiceChip(
label: Text(f),
selected: isSel,
selectedColor: AppColors.primaryNeon,
labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
onSelected: (_) => setState(() => selectedFilter = f),
),
);
}).toList(),
),
),
Expanded(
child: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: items.length,
itemBuilder: (context, index) {
final item = items[index];
return Card(
color: AppColors.cardBackground,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: ListTile(
leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.background, borderRadius:
BorderRadius.circular(8)), child: const Icon(Icons.fitness_center, color: AppColors.primaryNeon)),
title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
subtitle: Text(item.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
trailing: Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
decoration: BoxDecoration(color: item.isAvailable ? AppColors.success.withValues(alpha: 0.2) :
AppColors.warning.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
child: Text(item.isAvailable ? "Disponível" : "Manutenção", style: TextStyle(color: item.isAvailable ?
AppColors.success : AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold)),
),
),
);
},
),
),
],
);
},
),
);
}
}
class GestorMaintenanceTab extends StatefulWidget {
const GestorMaintenanceTab({super.key});
@override
State<GestorMaintenanceTab> createState() => _GestorMaintenanceTabState();
}
class _GestorMaintenanceTabState extends State<GestorMaintenanceTab> {
String selectedTab = "Pendentes";
@override
Widget build(BuildContext context) {
final state = AppState.instance;
return Scaffold(
appBar: AppBar(title: const Text("Manutenções")),
floatingActionButton: FloatingActionButton(
backgroundColor: AppColors.primaryNeon,
foregroundColor: Colors.black,
child: const Icon(Icons.add),
onPressed: () {},
),
body: ListenableBuilder(
listenable: state,
builder: (context, _) {
final list = state.maintenanceList.where((m) {
if (selectedTab == "Pendentes") return m.status == "Pendente";
if (selectedTab == "Em andamento") return m.status == "Em andamento";
return m.status == "Concluída";
}).toList();
return Column(
FITVYA PRO • main.dart atualizado • Página 43
children: [
Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
children: ["Pendentes", "Em andamento", "Concluídas"].map((tab) {
final isSel = selectedTab == tab;
return Expanded(
child: GestureDetector(
onTap: () => setState(() => selectedTab = tab),
child: Container(
padding: const EdgeInsets.symmetric(vertical: 10),
margin: const EdgeInsets.symmetric(horizontal: 4),
decoration: BoxDecoration(color: isSel ? AppColors.primaryNeon : AppColors.cardBackground, borderRadius:
BorderRadius.circular(8)),
child: Center(child: Text(tab, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight:
FontWeight.bold, fontSize: 12))),
),
),
);
}).toList(),
),
),
Expanded(
child: list.isEmpty
? const Center(child: Text("Nenhuma manutenção encontrada.", style: TextStyle(color: AppColors.textSecondary)))
: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: list.length,
itemBuilder: (context, index) {
final item = list[index];
Color priorityColor = AppColors.success;
if (item.priority == "Alta") priorityColor = AppColors.danger;
if (item.priority == "Média") priorityColor = AppColors.warning;
return Card(
color: AppColors.cardBackground,
margin: const EdgeInsets.only(bottom: 12),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(item.equipmentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
Container(
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.2), borderRadius:
BorderRadius.circular(12)),
child: Text("Prioridade: ${item.priority}", style: TextStyle(color: priorityColor, fontSize: 11,
fontWeight: FontWeight.bold)),
),
],
),
const SizedBox(height: 6),
Text(item.problemType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
],
),
),
);
},
),
),
],
);
},
),
);
}
}
class GestorProfileTab extends StatefulWidget {
const GestorProfileTab({super.key});
@override
State<GestorProfileTab> createState() => _GestorProfileTabState();
}
class _GestorProfileTabState extends State<GestorProfileTab> {
Future<void> _deleteGestorAccount() async {
final confirmed = await showDialog<bool>(
context: context,
builder: (_) => AlertDialog(
title: const Text("Excluir conta do gestor?"),
content: const Text(
"Tem certeza que quer excluir essa conta? Os dados administrativos da academia serão removidos deste dispositivo e essa ação não
ser desfeita.",
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text("CANCELAR"),
),
FITVYA PRO • main.dart atualizado • Página 44
ElevatedButton(
onPressed: () => Navigator.pop(context, true),
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.danger,
foregroundColor: Colors.white,
),
child: const Text("EXCLUIR CONTA"),
),
],
),
);
if (confirmed != true || !mounted) return;
final passwordController = TextEditingController();
final passwordConfirmed = await showDialog<bool>(
context: context,
builder: (_) => AlertDialog(
title: const Text("Digite sua senha"),
content: TextField(
controller: passwordController,
obscureText: true,
autofocus: true,
decoration: const InputDecoration(
labelText: "Senha cadastrada",
prefixIcon: Icon(Icons.lock_outline),
),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text("CANCELAR"),
),
ElevatedButton(
onPressed: () {
final ok = AppState.instance.deleteGestorAccount(
passwordController.text,
);
Navigator.pop(context, ok);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.danger,
foregroundColor: Colors.white,
),
child: const Text("CONFIRMAR EXCLUSÃO"),
),
],
),
);
passwordController.dispose();
if (!mounted) return;
if (passwordConfirmed == true) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Conta do gestor excluída com sucesso.")),
);
Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(builder: (_) => const LoginScreen()),
(_) => false,
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Senha incorreta. A conta não foi excluída."),
),
);
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Perfil do Gestor")),
body: ListView(
padding: const EdgeInsets.all(24),
children: [
const CircleAvatar(
radius: 40,
backgroundColor: AppColors.primaryNeon,
child: Icon(Icons.manage_accounts, size: 40, color: Colors.black),
),
const SizedBox(height: 16),
const Text(
"Gestor Administrativo",
textAlign: TextAlign.center,
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 4),
const Text(
"admin@academiafitlife.com.br",
textAlign: TextAlign.center,
FITVYA PRO • main.dart atualizado • Página 45
style: TextStyle(color: AppColors.textSecondary),
),
const SizedBox(height: 28),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
leading: const Icon(
Icons.lock_outline,
color: AppColors.primaryNeon,
),
title: const Text("Segurança da conta"),
subtitle: const Text(
"A senha será solicitada para excluir a conta.",
),
),
const SizedBox(height: 12),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.workspace_premium, color: AppColors.primaryNeon),
title: Text("Plano ${AppState.instance.gestorPlan}"),
subtitle: const Text("Mensal ou anual • R\$ 99,99/mês na versão final"),
trailing: const Icon(Icons.chevron_right, color: AppColors.primaryNeon),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GestorPlanScreen())),
),
const SizedBox(height: 12),
ListTile(
tileColor: AppColors.cardBackground,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.school_outlined, color: AppColors.primaryNeon),
title: const Text("Tutorial do FITVYA"),
subtitle: const Text("Guia opcional para aprender a usar o app"),
trailing: const Icon(Icons.chevron_right, color: AppColors.primaryNeon),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialScreen())),
),
const SizedBox(height: 16),
SizedBox(
height: 52,
child: ElevatedButton(
onPressed: () {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const LoginScreen()),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.cardBackground,
foregroundColor: Colors.white,
side: const BorderSide(color: AppColors.border),
),
child: const Text("SAIR DO SISTEMA"),
),
),
const SizedBox(height: 12),
SizedBox(
height: 52,
child: OutlinedButton.icon(
onPressed: _deleteGestorAccount,
icon: const Icon(
Icons.delete_forever,
color: AppColors.danger,
),
label: const Text(
"EXCLUIR CONTA",
style: TextStyle(
color: AppColors.danger,
fontWeight: FontWeight.bold,
),
),
style: OutlinedButton.styleFrom(
side: const BorderSide(color: AppColors.danger),
),
),
),
],
),
);
}
}