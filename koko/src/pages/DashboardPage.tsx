import React from 'react';
import { Container } from '../components/Container';

interface DashboardPageProps {
}

export const DashboardPage: React.FC<DashboardPageProps> = (props) => {
  return (
      <Container>
      <div>
          <h1>Welcome to the dashboard</h1>
      </div>
      </Container>
  ) ;
};