import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedAnswers: [Int: Int] = [:]
    @State private var showResults = false
    
    var canProceed: Bool {
        selectedAnswers.count == viewModel.questions.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if showResults {
                    QuizResultsView(score: calculateScore(), totalQuestions: viewModel.questions.count)
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            // Progress Header
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                HStack {
                                    Text("Assessment")
                                        .font(AppTypography.largeTitle)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                // Progress Bar
                                let progress = Double(selectedAnswers.count) / Double(viewModel.questions.count)
                                ProgressView(value: progress)
                                    .tint(AppColors.primary)
                                    .frame(height: 6)
                                
                                Text("Question \(selectedAnswers.count + 1) of \(viewModel.questions.count)")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(AppSpacing.lg)
                            
                            // Questions
                            VStack(spacing: AppSpacing.lg) {
                                ForEach(viewModel.questions.indices, id: \.self) { index in
                                    QuestionCard(
                                        question: viewModel.questions[index],
                                        index: index,
                                        selectedAnswer: selectedAnswers[index],
                                        onSelect: { answer in
                                            selectedAnswers[index] = answer
                                        }
                                    )
                                }
                            }
                            .padding(AppSpacing.lg)
                            
                            // Submit Button
                            Button(action: { showResults = true }) {
                                Text("Complete Assessment")
                                    .applyButtonStyle()
                            }
                            .disabled(!canProceed)
                            .opacity(canProceed ? 1.0 : 0.5)
                            .padding(AppSpacing.lg)
                            
                            Spacer()
                                .frame(height: AppSpacing.xl)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func calculateScore() -> Int {
        var score = 0
        for (index, answer) in selectedAnswers {
            if viewModel.questions[index].correctAnswer == answer {
                score += 1
            }
        }
        return score
    }
}

// MARK: - Question Card
struct QuestionCard: View {
    let question: QuizQuestion
    let index: Int
    let selectedAnswer: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Question Number and Title
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Question \(index + 1)")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.primary)
                    .fontWeight(.semibold)
                
                Text(question.question)
                    .font(AppTypography.headline)
                    .fontWeight(.semibold)
                    .lineLimit(nil)
            }
            
            Divider()
                .padding(.vertical, AppSpacing.sm)
            
            // Answer Options
            VStack(spacing: AppSpacing.md) {
                ForEach(question.options.indices, id: \.self) { optionIndex in
                    AnswerButton(
                        option: question.options[optionIndex],
                        isSelected: selectedAnswer == optionIndex,
                        onTap: { onSelect(optionIndex) }
                    )
                }
            }
        }
        .applyCardStyle()
    }
}

// MARK: - Answer Button
struct AnswerButton: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // Selection Indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppColors.primary : AppColors.border, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(option)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.text)
                    .lineLimit(nil)
                
                Spacer()
            }
            .padding(AppSpacing.md)
            .background(isSelected ? AppColors.primary.opacity(0.08) : AppColors.surface)
            .cornerRadius(AppRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(isSelected ? AppColors.primary : AppColors.border, lineWidth: 1)
            )
        }
    }
}

// MARK: - Quiz Results View
struct QuizResultsView: View {
    let score: Int
    let totalQuestions: Int
    @State private var navigateToIdeas = false
    
    var percentage: Int {
        (score * 100) / totalQuestions
    }
    
    var resultTitle: String {
        switch percentage {
        case 80...100:
            return "Excellent!"
        case 60..<80:
            return "Great!"
        case 40..<60:
            return "Good!"
        default:
            return "Keep Learning!"
        }
    }
    
    var resultDescription: String {
        "You scored \(score) out of \(totalQuestions)\nYour business ideas are ready!"
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            VStack(spacing: AppSpacing.lg) {
                // Score Circle
                ZStack {
                    Circle()
                        .stroke(AppColors.primary.opacity(0.1), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: Double(percentage) / 100)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.primary, AppColors.accent]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: percentage)
                    
                    VStack(spacing: AppSpacing.sm) {
                        Text("\(percentage)%")
                            .font(AppTypography.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.primary)
                        
                        Text("Score")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .frame(height: 200)
                
                VStack(spacing: AppSpacing.sm) {
                    Text(resultTitle)
                        .font(AppTypography.title2)
                        .fontWeight(.bold)
                    
                    Text(resultDescription)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .applyCardStyle()
            
            // Stats Grid
            HStack(spacing: AppSpacing.lg) {
                StatCard(title: "Correct", value: String(score), icon: "checkmark.circle", color: AppColors.success)
                StatCard(title: "Remaining", value: String(totalQuestions - score), icon: "circle", color: AppColors.warning)
            }
            .padding(AppSpacing.lg)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: AppSpacing.md) {
                NavigationLink(destination: BusinessIdeasView()) {
                    Text("View Your Ideas")
                        .applyButtonStyle()
                }
                
                Button(action: { }) {
                    Text("Retake Assessment")
                        .applySecondaryButtonStyle()
                }
            }
            .padding(AppSpacing.lg)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            VStack(spacing: AppSpacing.xs) {
                Text(value)
                    .font(AppTypography.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.lg)
        .background(color.opacity(0.08))
        .cornerRadius(AppRadius.lg)
    }
}

// MARK: - Quiz View Model
class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        questions = [
            QuizQuestion(
                question: "What's your primary motivation for starting a business?",
                options: ["Financial Freedom", "Creative Expression", "Problem Solving", "Building a Team"],
                correctAnswer: 0
            ),
            QuizQuestion(
                question: "How much startup capital do you have available?",
                options: ["Under $1,000", "$1,000-$10,000", "$10,000-$50,000", "$50,000+"],
                correctAnswer: 1
            ),
            QuizQuestion(
                question: "What's your preferred business model?",
                options: ["E-commerce", "Service-based", "SaaS", "Marketplace"],
                correctAnswer: 2
            ),
            QuizQuestion(
                question: "How many hours per week can you dedicate?",
                options: ["Less than 10", "10-20", "20-40", "40+"],
                correctAnswer: 3
            ),
            QuizQuestion(
                question: "What's your primary skill?",
                options: ["Technical", "Marketing", "Sales", "Management"],
                correctAnswer: 0
            )
        ]
    }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
}

#Preview {
    QuizView()
}
