import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 15) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .autocapitalization(.none)

                    ZStack(alignment: .trailing) {
                        Group {
                            if isSecure {
                                SecureField("Password", text: $password)
                            } else {
                                TextField("Password", text: $password)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                }

                NavigationLink(destination: TaskListView(), isActive: $isLoggedIn) {
                    EmptyView()
                }

                Button(action: {
                    // Always login successfully for now
                    isLoggedIn = true
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Spacer()

                Text("Don't have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 30)
        }
    }
}


#Preview {
    LoginView()
}
