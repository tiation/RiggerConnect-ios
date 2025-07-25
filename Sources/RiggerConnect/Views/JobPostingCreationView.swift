//
//  JobPostingCreationView.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import SwiftUI
import RiggerShared

public struct JobPostingCreationView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = JobPostingCreationViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var businessManager: BusinessManager
    @EnvironmentObject private var jobPostingManager: JobPostingManager
    
    @State private var showingPaymentSheet = false
    @State private var isPosting = false
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    jobBasicsSection
                    
                    locationSection
                    
                    requirementsSection
                    
                    compensationSection
                    
                    durationAndUrgencySection
                    
                    postingOptionsSection
                    
                    costSummarySection
                    
                    postJobButton
                }
                .padding()
            }
            .navigationTitle("Post a Job")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Draft") {
                        Task {
                            await viewModel.saveDraft()
                        }
                    }
                    .disabled(viewModel.jobTitle.isEmpty)
                }
            }
            .alert("Job Posted Successfully", isPresented: $viewModel.showingSuccessAlert) {
                Button("View Job") {
                    // Navigate to job details
                }
                Button("Post Another Job") {
                    viewModel.resetForm()
                }
                Button("Done") {
                    dismiss()
                }
            } message: {
                Text("Your job posting is now live and visible to riggers, doggers, and crane operators across Western Australia.")
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "briefcase.fill")
                    .font(.title2)
                    .foregroundColor(.riggerOrange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Find the Right Workers")
                        .font(.headline)
                    Text("Post a job and connect with qualified riggers, doggers, and crane operators in WA")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Job Basics Section
    
    private var jobBasicsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Job Details")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Job Title")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("e.g., Experienced Rigger - Mine Site", text: $viewModel.jobTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Job Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("Job Type", selection: $viewModel.selectedJobType) {
                    ForEach(JobType.allCases, id: \.self) { jobType in
                        Text(jobType.displayName).tag(jobType)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Job Description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $viewModel.jobDescription)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    // MARK: - Location Section
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location & Site Details")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Work Site Address")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter work site address", text: $viewModel.workSiteAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("City")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("City", text: $viewModel.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Postcode")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Postcode", text: $viewModel.postcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Site Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("Site Type", selection: $viewModel.selectedSiteType) {
                    ForEach(SiteType.allCases, id: \.self) { siteType in
                        Text(siteType.displayName).tag(siteType)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            accommodationToggle
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    private var accommodationToggle: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Accommodation Provided", isOn: $viewModel.accommodationProvided)
                .font(.subheadline)
            
            if viewModel.accommodationProvided {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Accommodation Type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Accommodation Type", selection: $viewModel.selectedAccommodationType) {
                        ForEach(AccommodationType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type as AccommodationType?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Toggle("Cost Covered by Company", isOn: $viewModel.accommodationCostCovered)
                        .font(.caption)
                }
                .padding(.leading)
            }
        }
    }
    
    // MARK: - Requirements Section
    
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requirements & Qualifications")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Experience Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("Experience Level", selection: $viewModel.selectedExperienceLevel) {
                    ForEach(ExperienceLevel.allCases, id: \.self) { level in
                        Text(level.displayName).tag(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Required Certifications")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(CertificationType.allCases.prefix(8), id: \.self) { certification in
                    HStack {
                        Button(action: {
                            if viewModel.selectedCertifications.contains(certification) {
                                viewModel.selectedCertifications.removeAll { $0 == certification }
                            } else {
                                viewModel.selectedCertifications.append(certification)
                            }
                        }) {
                            HStack {
                                Image(systemName: viewModel.selectedCertifications.contains(certification) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.selectedCertifications.contains(certification) ? .riggerOrange : .secondary)
                                
                                Text(certification.displayName)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Toggle("Drug & Alcohol Testing Required", isOn: $viewModel.drugAndAlcoholTesting)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    // MARK: - Compensation Section
    
    private var compensationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Compensation & Benefits")
                .font(.headline)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pay Type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Pay Type", selection: $viewModel.selectedPayType) {
                        ForEach(PayType.allCases, id: \.self) { payType in
                            Text(payType.displayName).tag(payType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount (AUD)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Amount", value: $viewModel.payAmount, format: .currency(code: "AUD"))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
            }
            
            overtimeSection
            
            allowancesSection
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    private var overtimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Overtime Available", isOn: $viewModel.overtimeAvailable)
                .font(.subheadline)
            
            if viewModel.overtimeAvailable {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Overtime Rate")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextField("1.5", value: $viewModel.overtimeRate, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("After Hours")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextField("8", value: $viewModel.overtimeAfterHours, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    private var allowancesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Allowances")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ForEach(AllowanceType.allCases.prefix(6), id: \.self) { allowanceType in
                HStack {
                    Button(action: {
                        if viewModel.selectedAllowances.contains(where: { $0.type == allowanceType }) {
                            viewModel.selectedAllowances.removeAll { $0.type == allowanceType }
                        } else {
                            viewModel.selectedAllowances.append(Allowance(type: allowanceType, amount: 0.0))
                        }
                    }) {
                        HStack {
                            Image(systemName: viewModel.selectedAllowances.contains(where: { $0.type == allowanceType }) ? "checkmark.square.fill" : "square")
                                .foregroundColor(viewModel.selectedAllowances.contains(where: { $0.type == allowanceType }) ? .riggerOrange : .secondary)
                            
                            Text(allowanceType.displayName)
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if viewModel.selectedAllowances.contains(where: { $0.type == allowanceType }) {
                                TextField("Amount", value: Binding(
                                    get: {
                                        viewModel.selectedAllowances.first(where: { $0.type == allowanceType })?.amount ?? 0.0
                                    },
                                    set: { newValue in
                                        if let index = viewModel.selectedAllowances.firstIndex(where: { $0.type == allowanceType }) {
                                            viewModel.selectedAllowances[index] = Allowance(type: allowanceType, amount: newValue)
                                        }
                                    }
                                ), format: .currency(code: "AUD"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Duration and Urgency Section
    
    private var durationAndUrgencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timeline & Priority")
                .font(.headline)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Duration", selection: $viewModel.selectedDuration) {
                        ForEach(JobDuration.allCases, id: \.self) { duration in
                            Text(duration.displayName).tag(duration)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Urgency")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Urgency", selection: $viewModel.selectedUrgency) {
                        ForEach(UrgencyLevel.allCases, id: \.self) { urgency in
                            Text(urgency.displayName).tag(urgency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                .font(.subheadline)
            
            if viewModel.selectedDuration != .permanent {
                DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    // MARK: - Posting Options Section
    
    private var postingOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Posting Options")
                .font(.headline)
            
            Toggle("Featured Listing (+$49)", isOn: $viewModel.featuredListing)
                .font(.subheadline)
            
            Toggle("Urgent Priority (+$29)", isOn: $viewModel.urgentPriority)
                .font(.subheadline)
            
            Toggle("Extended Duration (60 days) (+$19)", isOn: $viewModel.extendedDuration)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    // MARK: - Cost Summary Section
    
    private var costSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cost Summary")
                .font(.headline)
            
            HStack {
                Text("Base Job Posting")
                Spacer()
                Text("$79.00")
            }
            .font(.subheadline)
            
            if viewModel.featuredListing {
                HStack {
                    Text("Featured Listing")
                    Spacer()
                    Text("$49.00")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            if viewModel.urgentPriority {
                HStack {
                    Text("Urgent Priority")
                    Spacer()
                    Text("$29.00")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            if viewModel.extendedDuration {
                HStack {
                    Text("Extended Duration")
                    Spacer()
                    Text("$19.00")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.headline)
                Spacer()
                Text("$\(viewModel.totalCost, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.riggerOrange)
            }
            
            Text("Includes ChaseWhiteRabbit NGO contribution for worker empowerment programs")
                .font(.caption)
                .foregroundColor(.ngoGreen)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Post Job Button
    
    private var postJobButton: some View {
        Button(action: {
            Task {
                await postJob()
            }
        }) {
            HStack {
                if isPosting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "briefcase.fill")
                }
                
                Text(isPosting ? "Posting Job..." : "Post Job - $\(viewModel.totalCost, specifier: "%.2f")")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isFormValid ? Color.riggerOrange : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!viewModel.isFormValid || isPosting)
    }
    
    // MARK: - Methods
    
    private func postJob() async {
        isPosting = true
        
        do {
            let jobPosting = viewModel.createJobPosting(businessId: businessManager.currentUser?.id ?? UUID())
            
            // Process payment first
            await processPayment()
            
            // Then create the job posting
            await jobPostingManager.createJobPosting(jobPosting)
            
            viewModel.showingSuccessAlert = true
            
        } catch {
            // Handle error
            print("Error posting job: \(error)")
        }
        
        isPosting = false
    }
    
    private func processPayment() async {
        // Integrate with Stripe payment processing
        // This would show the payment sheet and process the payment
        showingPaymentSheet = true
    }
}

// MARK: - Preview

#Preview {
    JobPostingCreationView()
        .environmentObject(BusinessManager())
        .environmentObject(JobPostingManager())
}
